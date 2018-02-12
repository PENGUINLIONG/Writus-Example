# Writus-Example

Example site configuration using Writus

Remember to change the access token if you want to use these settings directly!

In directory `script`, there are example PowerShell scripts for you to:

* `Publish-Article`: Upload an entire article through the container directories. Multiple directories can be sent in. All recognized resource files like `*.jpg` and `*.png`, but of course, you can specify a MIME on your own. This script will call `Publish-File`.
* `Publish-File`: Upload a single file to the specified URI. **Change the variable `$Token` to your own access token before you use it**.
