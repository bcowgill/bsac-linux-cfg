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



Feature: Grant/remove admin status on Participants page
 Scenario: Owner,Admin user for Owner participant
  Given a table of logins and target user types with values:
        |UserType|ParticipantType|
        |Owner   |Owner          |
        |Admin   |Owner          |
        |Admin   |Admin          |
        |Member  |Owner          |
        |Member  |Admin          |
        |Member  |Member         |
   And a <UserType> user is on the Participants page
  When the <ParticipantType> user is shown on the list of participants
  Then there should be no menu icon for the <ParticipantType> user

 Scenario: Owner user for a Member
  Given an Owner user is on the Participants page
   And there is a Member user on the list of participants
  When the user activates the context menu for the Member user
  Then the menu should contain an entry called Grant admin rights
   And the menu should NOT contain an entry called Remove admin rights

 Scenario: Owner user for an Admin
  Given an Owner user is on the Participants page
   And there is an Admin user on the list of participants
  When the user activates the context menu for the Admin user
  Then the menu should contain an entry called Remove admin rights
   And the menu should NOT contain an entry called Grant admin rights

 Scenario: Admin user for a Member
  Given an Admin user is on the Participants page
   And there is a Member user on the list of participants
  When the user activates the context menu for the Member user
  Then the menu should NOT contain an entry called Grant admin rights

 Scenario: Admin user for an Admin
  Given an Admin user is on the Participants page
  When there is an Admin user on the list of participants
  Then there should be no menu icon for the Admin user

 Scenario: Member user
  Given a Member user is on the Participants page
  When the Member user is shown on the list of participants
  Then there should be no menu icon for any user type


Feature: Delete Deal on Dealroom page
 Scenario: Owner user can delete deal
  Given an Owner user is on the Dealroom page
  When the user clicks the Actions menu icon
  Then the Delete Deal item should be present under Admin Actions

 Scenario: Admin,Member user can NOT delete deal
  Given a table of UserType values:
        |UserType|
        |Admin   |
        |Member  |
  Given a <UserType> user is on the Dealroom page
  When the user clicks the Actions menu icon
  Then the Delete Deal item should NOT be present at all


Feature: Invite new Member on Dealroom page
 Scenario: Owner,Admin user can invite new members
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a <UserType> user is on the Dealroom page
  When the user clicks the Actions menu icon
  Then the Invite New User item should be present under Admin Actions

 Scenario: Member user can NOT invite new members
  Given a Member user is on the Dealroom page
  When the user clicks the Actions menu icon
  Then the Invite New User item should NOT be present at all


Feature: Invite new Member on Participants page
 Scenario: Owner,Admin user can invite new members
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a <UserType> user is on the Participants page
  When the user hovers over the Invite new participants button
  Then the Invite new participants button is enabled
   And there is NO tooltip shown

 Scenario: Member user can NOT invite new members
  Given a Member user is on the Participants page
  When the user hovers over the Invite new participants button
  Then the Invite new participants button is disabled
   And a tooltip is shown saying 'Only admins or the owner can perform this action'


Feature: Remove from deal on Participants page
 Scenario: Owner user for an Admin,Member
  Given a table of UserType values:
        |UserType|
        |Admin   |
        |Member  |
  Given an Owner user is on the Participants page
   And there is a <UserType> user on the list of participants
  When the user activates the context menu for the <UserType> user
  Then the menu should contain an entry called Remove from deal

 Scenario: Admin user for a Member
  Given an Admin user is on the Participants page
   And there is a Member user on the list of participants
  When the user activates the context menu for the Member user
  Then the menu should contain an entry called Remove from deal


Feature: Edit Checklist on Dealroom page
 Scenario: Owner,Admin user can edit checklist
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given an <UserType> user is on the Dealroom page
  When the user clicks the Actions menu icon
  Then the Edit Checklist item should be present under Admin Actions

 Scenario: Member user can NOT invite new members
  Given a Member user is on the Dealroom page
  When the user clicks the Actions menu icon
  Then the Edit Checklist item should NOT be present at all

Feature: Remove document version on Documents checklist page
 Scenario: Owners,Admins can delete versions
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a <UserType> user is on the Documents Checklist page
   And the last version of the document was created by someone else
  When the user hovers over the Delete Version link
  Then there is a Delete Version link displayed
   And the Delete Version link is enabled
   And there is NO tooltip shown

 Scenario: Members can NOT delete versions from others
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
  When the user hovers over the Delete Version link
  Then there is a Delete Version link displayed
   And the Delete Version link is DISABLED
   And a tooltip is shown saying 'Only admins or the owner can perform this action'

 Scenario: Members can delete their own versions
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by the Member
  When the user hovers over the Delete Version link
  Then there is a Delete Version link displayed
   And the Delete Version link is enabled
   And there is NO tooltip shown


Feature: Edit files on Documents checklist page
 Scenario: Owners,Admins can Edit files from others
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a <UserType> user is on the Documents Checklist page
   And the last version of the document was created by someone else
  When the user hovers over the Edit files link
  Then there is an Edit files link displayed
   And the Edit files link is enabled
   And there is NO tooltip shown

 Scenario: Members can NOT Edit files from others
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And the last version has a comparison file uploaded
  When the user hovers over the Edit files link
  Then there is an Edit files link displayed
   And the Edit files link is DISABLED
   And a tooltip is shown saying 'Only admins or the owner can perform this action'

 Scenario: Members can Edit files for their own versions
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by the Member
  When the user hovers over the Edit files link
  Then there is an Edit files link displayed
   And the Edit files link is enabled
   And there is NO tooltip shown

 Scenario: Members can Edit files for others when there is no comparison file
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And the last version has no comparison file uploaded
  When the user hovers over the Edit files link
  Then there is an Edit files link displayed
   And the Edit files link is enabled
   And there is NO tooltip shown


Feature: Members Remove Draft from upload dialog
 Scenario: Owners,Admins can remove draft for versions created by others
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a <UserType> user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And the last version has no comparison file uploaded
  When the user has clicked the Edit files link to open the uploader
  Then there should be an enabled icon to remove the draft file

 Scenario: Members can NOT remove draft for versions created by others
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And the last version has no comparison file uploaded
  When the user has clicked the Edit files link to open the uploader
  Then there should NOT be an icon to remove the draft file


Feature: Remove document version on Document Details page
 Scenario: Owners,Admins can delete versions
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a <UserType> user is on the Documents Checklist page
   And the last version of the document was created by someone else
  When the user has clicked the Details link to view document details
   And the user hovers over the Delete Version link in the Latest Version section
  Then there is a Delete Version link displayed
   And the Delete Version link is enabled
   And there is NO tooltip shown

 Scenario: Members can NOT delete versions from others
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
  When the user has clicked the Details link to view document details
   And the user hovers over the Delete Version link in the Latest Version section
  Then there is a Delete Version link displayed
   And the Delete Version link is DISABLED
   And a tooltip is shown saying 'Only admins or the owner can perform this action'

 Scenario: Members can delete their own versions
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by the Member
  When the user has clicked the Details link to view document details
   And the user hovers over the Delete Version link in the Latest Version section
  Then there is a Delete Version link displayed
   And the Delete Version link is enabled
   And there is NO tooltip shown


Feature: Edit files on Document Details page
 Scenario: Owners,Admins can Edit files from others
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a <UserType> user is on the Documents Checklist page
   And the last version of the document was created by someone else
  When the user has clicked the Details link to view document details
   And the user hovers over the Edit files link in the Latest Version section
  Then there is an Edit files link displayed
   And the Edit files link is enabled
   And there is NO tooltip shown

 Scenario: Members can NOT Edit files from others
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And the last version has a comparison file uploaded
  When the user has clicked the Details link to view document details
   And the user hovers over the Edit files link in the Latest Version section
  Then there is an Edit files link displayed
   And the Edit files link is DISABLED
   And a tooltip is shown saying 'Only admins or the owner can perform this action'

 Scenario: Members can Edit files for their own versions
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by the Member
  When the user has clicked the Details link to view document details
   And the user hovers over the Edit files link in the Latest Version section
  Then there is an Edit files link displayed
   And the Edit files link is enabled
   And there is NO tooltip shown

 Scenario: Members can Edit files for others when there is no comparison file
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And the last version has no comparison file uploaded
  When the user has clicked the Details link to view document details
   And the user hovers over the Edit files link in the Latest Version section
  Then there is an Edit files link displayed
   And the Edit files link is enabled
   And there is NO tooltip shown


Feature: Edit/Delete Status on Documents checklist page
 Scenario: Owners,Admins can Edit/Delete status
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a table of Link values:
        |Link    |
        |Edit    |
        |Delete  |
  Given a <UserType> user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And there is a status note that was created by someone else
  When the user hovers over the <Link> link in the Status column
  Then the <Link> link in the Status column is enabled
   And there is NO tooltip shown

 Scenario: Members can NOT Edit/Delete status
  Given a table of Link values:
        |Link  |
        |Edit  |
        |Delete|
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And there is a status note that was created by someone else
  When the user hovers over the <Link> link in the Status column
  Then the <Link> link in the Status column is DISABLED
   And a tooltip is shown saying 'Only admins or the owner can perform this action'


Feature: Edit/Delete Status on View all Status Notes from Documents Checklist page
 Scenario: Owners,Admins can Edit/Delete status
  Given a table of UserType values:
        |UserType|
        |Owner   |
        |Admin   |
  Given a table of Link values:
        |Link  |
        |Edit  |
        |Delete|
  Given a <UserType> user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And there is a status note that was created by someone else
  When the user clicks the View All link in the Status column
   And a number of status updates are shown to the user
   And the user hovers over the <Link> link for a status update
  Then all the <Link> links are enabled
   And there is NO tooltip shown

 Scenario: Members can NOT Edit/Delete status
  Given a table of Link values:
        |Link  |
        |Edit  |
        |Delete|
  Given a Member user is on the Documents Checklist page
   And the last version of the document was created by someone else
   And there is a status note that was created by someone else
  When the user clicks the View All link in the Status column
   And a number of status updates are shown to the user
   And the user hovers over the <Link> link for a status update
  Then all the <Link> links are DISABLED
   And a tooltip is shown saying 'Only admins or the owner can perform this action'


Feature: Unauthorized access generates info toast
 Scenario: Member user hacks the site
  Given a table of HackType values:
        |HackType|
        |the DISABLED Documents Checklist Delete Version link|
        |the DISABLED Documents Checklist Edit files link|
        |the DISABLED Document Details Delete Version link|
        |the DISABLED Document Details Edit files link|
        |the DISABLED Document Checklist Status Edit/Delete link in the Status column|
        |the DISABLED Document Checklist Status Edit/Delete link on the View All Status page|
        |the HIDDEN Dealroom page Invite New Member menu option|
        |the HIDDEN Dealroom page Edit checklist menu option|
        |the HIDDEN Participants page Invite New Member button|
  Given a Member user has bypassed button enablement for <HackType>
  When the user submits the unauthorized request
  Then the page is reloaded
   And an information toast appears saying 'You are not authorized to perform this action'

 Scenario: Admin,Member user hacks the site
  Given a table of UserType values:
        |UserType|
        |Admin   |
        |Member  |
  Given a table of TargetType values:
        |TargetType|
        |Owner     |
        |Admin     |
        |Member    |
  Given a table of HackType values:
        |HackType|
        |Grant admin rights to <TargetType>|
        |Remove admin rights from <TargetType>|
        |Remove <TargetType> from deal|
        |Remove deal|
  Given a <UserType> user has bypassed enablement for <HackType>
  When the user submits the unauthorized request
  Then the page is reloaded
   And an information toast appears saying 'You are not authorized to perform this action'

