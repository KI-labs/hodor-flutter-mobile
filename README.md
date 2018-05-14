# Hodor Mobile

Hodor is a an app that is developed to conveniently open the door of KI labs building in our Munich office. It is an improved version of the [Slack bot](https://github.com/KI-labs/Hodor) which was already developed by other team members.

## Getting Started

For help getting started with Flutter, view online
[documentation](https://flutter.io/).


## Conditions to make it run

This is a very custom project developed specifically for our use case but still it can be used 
for any access control system which works with an API call to open a door.   

If you checkout the codebase, you'll notice that it won't build because `network_config.dart` 
file is missing. It is an intentional step to hide our network configurations. A typical file would
contain following parameters.  

```
const String MAIN_URL = "<Enter URL here>";
const String API_AUTHORIZATION_USERNAME = "<Enter USERNAME here>";
const String API_AUTHORIZATION_PASSWORD = "<Enter PASSWORD here>";
```
