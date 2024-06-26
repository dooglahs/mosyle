# Mosyle Scripts, Tips, and Tricks

I've recently started working with Mosyle, but Mosyle's own documentation is scant (even if their support is phenomenal) and the community is relatively small. This is my attempt to make it a little less small.

I am currently using Mosyle's Business instance, though these should work just as well for the Education instances.

## Scripts

* Default Userspace Settings. Allows you to set default settings for the user where a profile might work, but you want to allow the user to later change the settings. Setting the Desktop Picture is an example.
* Default Userspace Settings ON ENROLLMENT. Similar to above, but allows you to set userspace settings on enrollment and user's first login.
* DEP Default Userspace Settings. Same as the above but works via the DEP process with limitations. See the header in the script for more information. Some improvements recommended by `adamcodega` on the MacAdmins Slack.
* Run Python Scripts. Mosyle doens't have the ability to run Python scripts from it's commands, so this bash script will drop the Python onto the computer and run it.
* Generic Plist Installer. This script allows you to deploy your own customized plist, and versions the plist so older versions can be updated over time.
* Custom attribute: AppleID. We had the need for a custom attribute to get the email AppleID on a machine if present. We named the attribute AppleID and it returns either the email address or "none".
* Custom attribute: Homebrew. Determines if Homebrew is installed or not; returns YES if it needs an update else NO.

## Tips

None at this time except to join the MacAdmins Slack channel!

## Tricks

None at this time, though I intend to describe how I use device groups with criteria eventually.

## Mosyle Variables

You can use the following specifically within custom commands.

**Variables available for all devices**
|  Item | Variable |
| :--- | :--- |
| Company Name | %CompanyName% |
| Current device name | %DeviceName% |
| Device UDID | %UUID% |
| Serial Number | %SerialNumber% |
| Asset Tag | %AssetTag% |
| WiFi Mac Address | %WiFiMac% |
| Product Name | %ProductName% |
| OS version | %OSVersion% |
| Sequencial number | %Number% 
| Current year | %Year% |
| Last Console User | %LastConsoleUser% |
| Mosyle CDN File | (clickable link in your portal) |
| Dep Password | %dep_password% |
| Tags | %Tags% |

**Variables available only for 1:1 devices**
|  Item | Variable |
| :--- | :--- |
| Full Name | %FullName% |
| First Name | %FirstName% |
| Last Name | %LastName% |
| Email | %Email% |
| Email Prefix | %EmailPrefix% |
| User ID | %UserId% |
| Managed Apple ID | %ManagedAppleId% |
| Managed Apple ID Prefix | %ManagedAppleIdPrefix% |
| User Type | %UserType% |

**Variables from Custom Device Attributes**
Mosyle will also now present variables you can use from custom attributes. The following is from an attribute generated from [this script](https://github.com/dooglahs/mosyle/blob/master/mosyle-custom-attribute-homebrew-update.sh)
|  Item | Variable |
| :--- | :--- |
| Homebrew Update Needed? | %custom_cc_brewUpdateNeeded% |
