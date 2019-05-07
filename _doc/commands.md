# CI auth github commands

## OAuth
curl -H "Authorization: token OAUTH-TOKEN" https://api.github.com
(https://developer.github.com/v3/#oauth2-token-sent-in-a-header)


## Basic Auth: Detailed example of post for creating a pull request with body detail
curl -u adamchenwei --header "Content-Type: application/json" --request POST --data '{"title": "Amazing new feature","body": "Please pull this in!","head": "adamchenwei:new-new-new","base": "master"}' https://api.github.com/repos/adamchenwei/vuejs-to-reactjs-conversion/pulls


## OAuth: Detailed example of post for creating a pull request with body detail
curl -H "Authorization: token ${bamboo_chewbot_github_token_password}" --header "Content-Type: application/json" --request POST --data '{"title": "Amazing new feature","body": "Please pull this in!","head": "adamchenwei:test-abc-abc","base": "master"}' https://api.github.com/repos/Chewy-Inc/storefront/pulls


curl -u adamchenwei --header "Content-Type: application/json" --request POST --data '{"title": "Amazing new feature","body": "Please pull this in!","head": "adamchenwei:test-abc-abc","base": "master"}' https://api.github.com/repos/Chewy-Inc/storefront/pulls
// NOTE: THE `head` can be ONLY the branch name instead of both username and branch name!!!! for internal branch merging and not from a forked version from another user