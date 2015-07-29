Conditions of Satisfaction for Feature 28395
(aka Acceptance Criteria)

14 Features / 38 Scenarios

(
   Structure of language explained here:

   https://cucumber.io/docs/reference#gherkin
   https://github.com/cucumber/cucumber/wiki/Gherkin
   https://github.com/cucumber/cucumber/wiki/Feature-Introduction
   https://github.com/cucumber/cucumber/wiki/Given-When-Then
   FOR .. IN and SETTING .. TO are NOT part of gherkin/cucumber (they may have something similar)
)

# Sample of cucumber syntax from 
# https://cucumber.io/docs/reference#gherkin
# should be one Feature per .feature file
Feature: Refund item

  Sales assistants should be able to refund customers' purchases.
  This is required by the law, and is also essential in order to
  keep customers happy.

  Rules:
  - Customer must present proof of purchase
  - Purchase must be less than 30 days ago

# Background: clauses will execute for all scenarios in the feature
Background:
  Given some state present in all features
  And some more state for all features

Scenario: feeding a small suckler cow
  Given the cow weighs 450 kg
  When we calculate the feeding requirements
  Then the energy should be 26500 MJ
  And the protein should be 215 kg
  But the fat should only be 14 g

# Putting as many @Tags as you like before a Feature/Scenario
# will make it easy to run a subset of scenarios which match 
# or exclude specific tags.
# https://cucumber.io/docs/reference#tagged-hooks
@demo @withtable
Scenario Outline: feeding a suckler cow
  Given the cow weighs <weight> kg
  When we calculate the feeding requirements
  Then the energy should be <energy> MJ
  And the protein should be <protein> kg

  Examples:
    | weight | energy | protein |
    |    450 |  26500 |     215 |
    |    500 |  29500 |     245 |
    |    575 |  31500 |     255 |
    |    600 |  37000 |     305 |

@demo
Scenario: demonstrating a multiline doc string 
  Given a blog post named "Random" with Markdown body
    """
    Some Title, Eh?
    ===============
    Here is the first paragraph of my blog post. Lorem ipsum dolor sit amet,
    consectetur adipiscing elit.
    """

@demo @withtable @task2341 @wip
Scenario: demonstrating a data table in a scenario
  Given the following users exist:
    | name   | email              | twitter         |
    | Aslak  | aslak@cucumber.io  | @aslak_hellesoy |
    | Julien | julien@cucumber.io | @jbpros         |
    | Matt   | matt@cucumber.io   | @mattwynne      |
  When the user types <name> TODO what syntax to acces the vars?



FEATURE: Grant/remove admin status on Participants page
 SCENARIO: Owner,Admin user for Owner participant
  GIVEN a table of logins and target user types with values:
  |UserType|ParticipantType|
  |Owner    |Owner           |
  |Admin    |Owner           |
  |Admin    |Admin           |
  |Member   |Owner           |
  |Member   |Admin           |
  |Member   |Member          |
   and a $UserType user is on the Participants page
  WHEN the $ParticipantType user is shown on the list of participants
  THEN there should be no menu icon for the $ParticipantType user

 SCENARIO: Owner user for a Member
  GIVEN an Owner user is on the Participants page
   and there is a Member user on the list of participants
  WHEN the user activates the context menu for the Member user
  THEN the menu should contain an entry called Grant admin rights
   and the menu should NOT contain an entry called Remove admin rights

 SCENARIO: Owner user for an Admin
  GIVEN an Owner user is on the Participants page
   and there is an Admin user on the list of participants
  WHEN the user activates the context menu for the Admin user
  THEN the menu should contain an entry called Remove admin rights
   and the menu should NOT contain an entry called Grant admin rights

 SCENARIO: Admin user for a Member
  GIVEN an Admin user is on the Participants page
   and there is a Member user on the list of participants
  WHEN the user activates the context menu for the Member user
  THEN the menu should NOT contain an entry called Grant admin rights

 SCENARIO: Admin user for an Admin
  GIVEN an Admin user is on the Participants page
  WHEN there is an Admin user on the list of participants
  THEN there should be no menu icon for the Admin user

 SCENARIO: Member user
  GIVEN a Member user is on the Participants page
  WHEN the Member user is shown on the list of participants
  THEN there should be no menu icon for any user type


FEATURE: Delete Deal on Dealroom page
 SCENARIO: Owner user can delete deal
  GIVEN an Owner user is on the Dealroom page
  WHEN the user clicks the Actions menu icon
  THEN the Delete Deal item should be present under Admin Actions

 SCENARIO: Admin,Member user can NOT delete deal
  FOR $UserType IN Admin, Member
  GIVEN a $UserType user is on the Dealroom page
  WHEN the user clicks the Actions menu icon
  THEN the Delete Deal item should NOT be present at all


FEATURE: Invite new Member on Dealroom page
 SCENARIO: Owner,Admin user can invite new members
  FOR $UserType IN Owner, Admin
  GIVEN a $UserType user is on the Dealroom page
  WHEN the user clicks the Actions menu icon
  THEN the Invite New User item should be present under Admin Actions

 SCENARIO: Member user can NOT invite new members
  GIVEN a Member user is on the Dealroom page
  WHEN the user clicks the Actions menu icon
  THEN the Invite New User item should NOT be present at all


FEATURE: Invite new Member on Participants page
 SCENARIO: Owner,Admin user can invite new members
  FOR $UserType IN Owner, Admin
  GIVEN a $UserType user is on the Participants page
  WHEN the user hovers over the Invite new participants button
  THEN the Invite new participants button is enabled
   and there is NO tooltip shown

 SCENARIO: Member user can NOT invite new members
  GIVEN a Member user is on the Participants page
  WHEN the user hovers over the Invite new participants button
  THEN the Invite new participants button is disabled
   and a tooltip is shown saying 'Only admins or the owner can perform this action'


FEATURE: Remove from deal on Participants page
 SCENARIO: Owner user for an Admin,Member
  FOR $UserType IN Admin, Member
  GIVEN an Owner user is on the Participants page
   and there is a $UserType user on the list of participants
  WHEN the user activates the context menu for the $UserType user
  THEN the menu should contain an entry called Remove from deal

 SCENARIO: Admin user for a Member
  GIVEN an Admin user is on the Participants page
   and there is a Member user on the list of participants
  WHEN the user activates the context menu for the Member user
  THEN the menu should contain an entry called Remove from deal


FEATURE: Edit Checklist on Dealroom page
 SCENARIO: Owner,Admin user can edit checklist
  FOR $UserType IN Owner, Admin
  GIVEN an $UserType user is on the Dealroom page
  WHEN the user clicks the Actions menu icon
  THEN the Edit Checklist item should be present under Admin Actions

 SCENARIO: Member user can NOT invite new members
  GIVEN a Member user is on the Dealroom page
  WHEN the user clicks the Actions menu icon
  THEN the Edit Checklist item should NOT be present at all

FEATURE: Remove document version on Documents checklist page
 SCENARIO: Owners,Admins can delete versions
  FOR $UserType IN Owner, Admin
  GIVEN a $UserType user is on the Documents Checklist page
   and the last version of the document was created by someone else
  WHEN the user hovers over the Delete Version link
  THEN there is a Delete Version link displayed
   and the Delete Version link is enabled
   and there is NO tooltip shown

 SCENARIO: Members can NOT delete versions from others
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
  WHEN the user hovers over the Delete Version link
  THEN there is a Delete Version link displayed
   and the Delete Version link is DISABLED
   and a tooltip is shown saying 'Only admins or the owner can perform this action'

HEREIAM
 SCENARIO: Members can delete their own versions
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by the Member
  WHEN the user hovers over the Delete Version link
  THEN there is a Delete Version link displayed
   and the Delete Version link is enabled
   and there is NO tooltip shown


FEATURE: Edit files on Documents checklist page
 SCENARIO: Owners,Admins can Edit files from others
  FOR $UserType IN Owner, Admin
  GIVEN a $UserType user is on the Documents Checklist page
   and the last version of the document was created by someone else
  WHEN the user hovers over the Edit files link
  THEN there is an Edit files link displayed
   and the Edit files link is enabled
   and there is NO tooltip shown

 SCENARIO: Members can NOT Edit files from others
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and the last version has a comparison file uploaded
  WHEN the user hovers over the Edit files link
  THEN there is an Edit files link displayed
   and the Edit files link is DISABLED
   and a tooltip is shown saying 'Only admins or the owner can perform this action'

 SCENARIO: Members can Edit files for their own versions
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by the Member
  WHEN the user hovers over the Edit files link
  THEN there is an Edit files link displayed
   and the Edit files link is enabled
   and there is NO tooltip shown

 SCENARIO: Members can Edit files for others when there is no comparison file
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and the last version has no comparison file uploaded
  WHEN the user hovers over the Edit files link
  THEN there is an Edit files link displayed
   and the Edit files link is enabled
   and there is NO tooltip shown


FEATURE: Members Remove Draft from upload dialog
 SCENARIO: Owners,Admins can remove draft for versions created by others
  FOR $UserType IN Owner, Admin
  GIVEN a $UserType user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and the last version has no comparison file uploaded
  WHEN the user has clicked the Edit files link to open the uploader
  THEN there should be an enabled icon to remove the draft file

 SCENARIO: Members can NOT remove draft for versions created by others
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and the last version has no comparison file uploaded
  WHEN the user has clicked the Edit files link to open the uploader
  THEN there should NOT be an icon to remove the draft file


FEATURE: Remove document version on Document Details page
 SCENARIO: Owners,Admins can delete versions
  FOR $UserType IN Owner, Admin
  GIVEN a $UserType user is on the Documents Checklist page
   and the last version of the document was created by someone else
  WHEN the user has clicked the Details link to view document details
   and the user hovers over the Delete Version link in the Latest Version section
  THEN there is a Delete Version link displayed
   and the Delete Version link is enabled
   and there is NO tooltip shown

 SCENARIO: Members can NOT delete versions from others
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
  WHEN the user has clicked the Details link to view document details
   and the user hovers over the Delete Version link in the Latest Version section
  THEN there is a Delete Version link displayed
   and the Delete Version link is DISABLED
   and a tooltip is shown saying 'Only admins or the owner can perform this action'

 SCENARIO: Members can delete their own versions
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by the Member
  WHEN the user has clicked the Details link to view document details
   and the user hovers over the Delete Version link in the Latest Version section
  THEN there is a Delete Version link displayed
   and the Delete Version link is enabled
   and there is NO tooltip shown


FEATURE: Edit files on Document Details page
 SCENARIO: Owners,Admins can Edit files from others
  FOR $UserType IN Owner, Admin
  GIVEN a $UserType user is on the Documents Checklist page
   and the last version of the document was created by someone else
  WHEN the user has clicked the Details link to view document details
   and the user hovers over the Edit files link in the Latest Version section
  THEN there is an Edit files link displayed
   and the Edit files link is enabled
   and there is NO tooltip shown

 SCENARIO: Members can NOT Edit files from others
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and the last version has a comparison file uploaded
  WHEN the user has clicked the Details link to view document details
   and the user hovers over the Edit files link in the Latest Version section
  THEN there is an Edit files link displayed
   and the Edit files link is DISABLED
   and a tooltip is shown saying 'Only admins or the owner can perform this action'

 SCENARIO: Members can Edit files for their own versions
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by the Member
  WHEN the user has clicked the Details link to view document details
   and the user hovers over the Edit files link in the Latest Version section
  THEN there is an Edit files link displayed
   and the Edit files link is enabled
   and there is NO tooltip shown

 SCENARIO: Members can Edit files for others when there is no comparison file
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and the last version has no comparison file uploaded
  WHEN the user has clicked the Details link to view document details
   and the user hovers over the Edit files link in the Latest Version section
  THEN there is an Edit files link displayed
   and the Edit files link is enabled
   and there is NO tooltip shown


FEATURE: Edit/Delete Status on Documents checklist page
 SCENARIO: Owners,Admins can Edit/Delete status
  FOR $UserType IN Owner, Admin
  FOR $Link IN Edit, Delete
  GIVEN a $UserType user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and there is a status note that was created by someone else
  WHEN the user hovers over the $Link link in the Status column
  THEN the $Link link in the Status column is enabled
   and there is NO tooltip shown

 SCENARIO: Members can NOT Edit/Delete status
  FOR $Link IN Edit, Delete
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and there is a status note that was created by someone else
  WHEN the user hovers over the $Link link in the Status column
  THEN the $Link link in the Status column is DISABLED
   and a tooltip is shown saying 'Only admins or the owner can perform this action'


FEATURE: Edit/Delete Status on View all Status Notes from Documents Checklist page
 SCENARIO: Owners,Admins can Edit/Delete status
  FOR $UserType IN Owner, Admin
  FOR $Link IN Edit, Delete
  GIVEN a $UserType user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and there is a status note that was created by someone else
  WHEN the user clicks the View All link in the Status column
   and a number of status updates are shown to the user
   and the user hovers over the $Link link for a status update
  THEN all the $Link links are enabled
   and there is NO tooltip shown

 SCENARIO: Members can NOT Edit/Delete status
  FOR $Link IN Edit, Delete
  GIVEN a Member user is on the Documents Checklist page
   and the last version of the document was created by someone else
   and there is a status note that was created by someone else
  WHEN the user clicks the View All link in the Status column
   and a number of status updates are shown to the user
   and the user hovers over the $Link link for a status update
  THEN all the $Link links are DISABLED
   and a tooltip is shown saying 'Only admins or the owner can perform this action'


FEATURE: Unauthorized access generates info toast
 SCENARIO: Member user hacks the site
  FOR $HackType IN
   the DISABLED Documents Checklist Delete Version link
   the DISABLED Documents Checklist Edit files link
   the DISABLED Document Details Delete Version link
   the DISABLED Document Details Edit files link
   the DISABLED Document Checklist Status Edit/Delete link in the Status column
   the DISABLED Document Checklist Status Edit/Delete link on the View All Status page
   the HIDDEN Dealroom page Invite New Member menu option
   the HIDDEN Dealroom page Edit checklist menu option
   the HIDDEN Participants page Invite New Member button
  GIVEN a Member user has bypassed button enablement for $HackType
  WHEN the user submits the unauthorized request
  THEN the page is reloaded
   and an information toast appears saying 'You are not authorized to perform this action'

 SCENARIO: Admin,Member user hacks the site
  FOR $UserType in Admin, Member
  FOR $TargetType in Owner, Admin, Member
  FOR $HackType IN
   Grant admin rights to $TargetType
   Remove admin rights from $TargetType
   Remove $TargetType from deal
   Remove deal
  GIVEN a $UserType user has bypassed enablement for $HackType
  WHEN the user submits the unauthorized request
  THEN the page is reloaded
   and an information toast appears saying 'You are not authorized to perform this action'

perl -pne 's{FOR \s+ \$(\w+) \s+ IN \s+ (.+) \n \z}{qq{GIVEN a table of $1 values:\n  |@{[join(qq{|\n}, split(/,\s+/,$2))]}}}xmse' gherkin-cucumber.feature | less

