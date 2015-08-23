/*jshint maxcomplexity: 6 */
/*global define*/

define(function (require) {
    'use strict';

    var Marionette = require('backbone.marionette'),
        SignatureUploaderController = require('uploaders/controllers/SignatureUploaderController'),
        SingleFileUploaderController = require('uploaders/controllers/SingleFileUploaderController'),
        SingleFileWithNameUploaderController = require('uploaders/controllers/SingleFileWithNameUploaderController'),
        FileVersionUploaderController = require('uploaders/controllers/FileVersionUploaderController'),
        _ = require('underscore'),
        FIRST_VERSION = 1,
        FIRST_COMPARISON_VERSION = 2,
        NOT_FOUND = -1;

    return Marionette.Controller.extend({
        fieldsFromOptions: [
            'title',
            'uploadType',
            'mixpanelUploadType',
            'isEditVersion',
            'autoComparisonStatus',
            'partiesObject',
            'container',
            'onAfterRender'
        ],

        fieldsRenamedFromDataAttributes: [
            'isDocumentPage:controller',
            'documentId',
            'documentVersionId',
            'dealroomUuid:dealroomExternalUuid'
        ],

        fieldsFromApi: [
            'versionNumber',
            'draftFilename',
            'draftId',
            'editCustomAuthorizedDraft',
            'comparisonFilename',
            'comparisonId',
            'editCustomAuthorizedComparison',
            'previousDraftName',
            'versionsCount'
        ],

        /** @private */
        initialize: function (options) {
            this._getInitOptions(options);
            this._getDataAttributeOptions();
            this._getApiOptions();
        },

        getSingleFileUploader: function () {
            var self = this;
            self._getNewUploader(function () {
                self.uploaderController = new SingleFileUploaderController(self.initOptions);
                self.listenTo(self.uploaderController,
                    'upload:submitToDealroom',
                    _.bind(self._uploadDocumentFile, self));
            });
        },

        getFileUploaderWithAssignedParties: function () {
            var self = this;
            self._getNewUploader(function () {
                self.uploaderController = new SignatureUploaderController(self.initOptions);
                self.listenTo(self.uploaderController,
                    'upload:submitToDealroom',
                    _.bind(self._uploadDocumentFile, self));
            });
        },

        getFileUploaderWithInputFileName: function () {
            var self = this;
            self._getNewUploader(function () {
                self.uploaderController = new SingleFileWithNameUploaderController(self.initOptions);
                self.listenTo(self.uploaderController,
                    'upload:submitToDealroom',
                    _.bind(self._uploadDocumentFile, self));
            });
        },

        getFileUploaderWithComparison: function () {
            var self = this;
            self._getNewUploader(function () {
                self.uploaderController = new FileVersionUploaderController(self.initOptions);
                self.listenTo(self.uploaderController,
                    'upload:submitToDealroom',
                    _.bind(self._uploadDocumentVersion, self));
                self.listenTo(self.uploaderController,
                    'autocomparison:generated',
                    _.bind(self._autoComparisonGenerated, self));
                self.listenTo(self.uploaderController,
                    'autocomparison:fail:generated',
                    _.bind(self._autoComparisonGeneratedFail, self));
            });
        },

        /** @private */
        _getNewUploader: function (fnOnApiResults) {
            if (this.apiResults)
            {
                fnOnApiResults();
            }
            else
            {
                this.afterApiResults = fnOnApiResults;
            }
        },

        /** @private */
        _getInitOptions: function (options) {
            this.container = options.container;
            this.initOptions = _.pick(options, this.fieldsFromOptions);
            this.initOptions.isEditVersion = this.initOptions.isEditVersion || false;
        },

        /** @private */
        _getDataAttributeOptions: function () {
            var dataAttributes = this.container.data();

            _defaultsRenamed(this.initOptions, dataAttributes, this.fieldsRenamedFromDataAttributes);
            this.initOptions.isDocumentPage = (this.initOptions.isDocumentPage === 'show');
        },

        /** @private */
        _getApiOptions: function () {
            $.ajax({
                url: this._getUrl(),
                type: 'GET'
            })
                .done(_.bind(function (oApiResponse) {
                    this._parseApiResults(oApiResponse);
                    if (this.afterApiResults) {
                        this.afterApiResults();
                    }
                }, this));
        },

        /** @private */
        _getUrl: function (documentId) {
            documentId = documentId || this.initOptions.documentId;
            return '/dealroom/api/v1/documents/' + documentId + '/document_files.json';
        },

        /** @private */
        _parseApiResults: function (oApiResponse) {
            this.apiResults = oApiResponse;
            var aEntries = this.apiResults.entries;

            if (aEntries && aEntries.length)
            {
                this._parseApiVersionsCount();
                this._parseApiDraftInfo();
                this._parseApiComparisonInfo();
                this._parseApiPreviousDraftName();
            }
        },

        /** @private */
        _parseApiDraftInfo: function () {
            var aEntries = this.apiResults.entries,
                indexOfVersion = this._findVersionIdInApiResults('DraftDocumentFile');

            if (indexOfVersion !== NOT_FOUND) {
                this.initOptions.versionNumber = aEntries[indexOfVersion].document_version.version;
                this.initOptions.draftFilename = aEntries[indexOfVersion].filename || '';
                this.initOptions.draftId = aEntries[indexOfVersion].id;
                this.initOptions.editCustomAuthorizedDraft = aEntries[indexOfVersion].permissions && aEntries[indexOfVersion].permissions.edit;
            }
        },

        /** @private */
        _parseApiComparisonInfo: function () {
            var aEntries = this.apiResults.entries,
                indexOfVersion = this._findVersionIdInApiResults('ComparisonDocumentFile');

            if (indexOfVersion !== NOT_FOUND) {
                this.initOptions.comparisonFilename = aEntries[indexOfVersion].filename || '';
                this.initOptions.comparisonId = aEntries[indexOfVersion].id;
                this.initOptions.editCustomAuthorizedComparison =
                    aEntries[indexOfVersion].permissions &&
                    aEntries[indexOfVersion].permissions.edit;
            }
        },

        /** @private */
        _parseApiPreviousDraftName: function () {
            var aEntries = this.apiResults.entries,
                indexOfVersion = NOT_FOUND;

            if (this.initOptions.versionNumber >= FIRST_COMPARISON_VERSION) {
                indexOfVersion = this._findVersionNumberInApiResults(
                    'DraftDocumentFile',
                    this.initOptions.versionNumber - 1);
            }
            else if (this._isNewUploadVersion() &&
                this.initOptions.versionsCount === FIRST_VERSION) {
                indexOfVersion = this._findVersionNumberInApiResults(
                    'DraftDocumentFile',
                    1);
            }
            if (indexOfVersion !== NOT_FOUND) {
                this.initOptions.previousDraftName = aEntries[indexOfVersion].filename || '';
            }
        },

        /** @private */
        _parseApiVersionsCount: function () {
            var aEntries = this.apiResults.entries;

            this.initOptions.versionsCount = _.max(aEntries, function (anEntry) {
                return anEntry.document_version && anEntry.document_version.version;
            });
            if (this.initOptions.versionsCount !== -Infinity) {
                this.initOptions.versionsCount = this.initOptions.versionsCount.document_version.version;
                if (this._isNewUploadVersion()) {
                    this.initOptions.versionNumber = this.initOptions.versionsCount + 1;
                }
            }
        },

        /** @private */
        _findVersionIdInApiResults: function (type) {
            var aEntries = this.apiResults.entries,
                indexOfVersion = _.findIndex(aEntries, function (anEntry) {
                    return (anEntry.type === type &&
                    anEntry.document_version &&
                    anEntry.document_version.id === this.initOptions.documentVersionId);
                }, this);
            return indexOfVersion;
        },

        /** @private */
        _findVersionNumberInApiResults: function (type, version) {
            var aEntries = this.apiResults.entries,
                indexOfVersion = _.findIndex(aEntries, function (anEntry) {
                    return (anEntry.type === type &&
                    anEntry.document_version &&
                    anEntry.document_version.version === version);
                }, this);
            return indexOfVersion;
        },

        /** @private */
        _uploadDocumentFile: function (params) {
            $.ajax({
                url: this._getUrl(params.documentId),
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(params.data),
                processData: false
            })
                .done(_.bind(this._onUploadDone, this));
        },

        /** @private */
        _uploadDocumentVersion: function (params) {
            $.ajax(params.ajaxOptions)
                .fail(_.bind(this._onUnauthorizedAction,this))
                .always(_.bind(this._onUploadDone, this));
        },

        _isNewUploadVersion: function () {
            return !this.initOptions.isEditVersion;
        },

        _onUploadDone: function () {
            this.container.trigger('upload:done');
            if (this.uploaderController) {
                this.uploaderController.resetUploader();
            }
        },

        _autoComparisonGenerated: function (params) {
            this.container.trigger('autocomparison:generated', params);
        },

        _autoComparisonGeneratedFail: function (params) {
            this.container.trigger('autocomparison:fail:generated', params);
        },

        _onUnauthorizedAction: function (jxhr){
            if(jxhr.status === 403){
                this._setInvalid();
            }
        },

        _defaultsRenamed: function (options, defaults, keys) {
            keys.forEach(function (keyToRename) {
                var rename, original, aRename = keyToRename.split(':');
                rename = aRename[0];
                original = aRename.length > 1 ? aRename[1] : rename;
                options[rename] = defaults[original];
            });
        }
    });
});
