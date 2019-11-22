#!/usr/bin/env bash

set -e
set -x

echo "$BUILD_ENVVAR"
echo "Setting environment variables"

if [ "$BUILD_ENVVAR" == 'production' ]; then
    echo 'Setting production env'

    echo "{" > env.json
    echo "\"MAPBOX_TOKEN\": \"$MAPBOX_TOKEN\"," >> env.json
    echo "\"AUTH0_CLIENT_ID\": \"$AUTH0_CLIENT_ID\"," >> env.json
    echo "\"AUTH0_DOMAIN\": \"$AUTH0_DOMAIN\"," >> env.json
    echo "\"AUTH0_AUDIENCE_DOMAIN\": \"$AUTH0_AUDIENCE_DOMAIN\"," >> env.json
    echo "\"AWS_BASE_URL\": \"$AWS_BASE_URL\"," >> env.json
    echo "\"AWS_PROFILE\": \"$AWS_PROFILE\"," >> env.json
    echo "\"AWS_USERS\": \"$AWS_USERS\"," >> env.json
    echo "\"AWS_ORDERS\": \"$AWS_ORDERS\"," >> env.json
    echo "\"AWS_EXPERIENCE\": \"$AWS_EXPERIENCE\"," >> env.json
    echo "\"AWS_EVENTS\": \"$AWS_EVENTS\"," >> env.json
    echo "\"AWS_HAPPENING\": \"$AWS_HAPPENING\"," >> env.json
    echo "\"AWS_NOTIFICATION\": \"$AWS_NOTIFICATION\"," >> env.json
    echo "\"AWS_MESSAGE\": \"$AWS_MESSAGE\"," >> env.json
    echo "\"AWS_COMPETITION\": \"$AWS_COMPETITION\"," >> env.json
    echo "\"AWS_LOGGING\": \"$AWS_LOGGING\"," >> env.json
    echo "\"AWS_GEOLOCATION\": \"$AWS_GEOLOCATION\"," >> env.json
    echo "\"STRIPE_PUB_KEY\": \"$STRIPE_PUB_KEY\"," >> env.json
    echo "\"GCM_SENDER_ID\": \"$GCM_SENDER_ID\"," >> env.json
    echo "\"CODEPUSH_API_KEY\": \"$CODEPUSH_KEY\"," >> env.json
    echo "\"APPSFLYER_KEY\": \"$APPSFLYER_KEY\"," >> env.json
    echo "\"APPSFLYER_APP_ID\": \"$APPSFLYER_APP_ID\"," >> env.json
    echo "\"FABRIC_API_KEY\": \"$FABRIC_API_KEY\"," >> env.json
    echo "\"YOUTUBE_API_KEY\": \"$YOUTUBE_API_KEY\"," >> env.json
    echo "\"GEOLOCATION_LICENCE_KEY\": \"$GEOLOCATION_LICENCE_KEY\"," >> env.json
    echo "\"AWS_SECRET_KEY\": \"$AWS_SECRET_KEY\"," >> env.json
    echo "\"AWS_ACCESS_KEY\": \"$AWS_ACCESS_KEY\"," >> env.json
    echo "\"AWS_API_REGION\": \"$AWS_API_REGION\"," >> env.json
# the last line doesn't have a trailing comma
    echo "\"MAPBOX_API_BASE_URL\": \"$MAPBOX_API_BASE_URL\"" >> env.json
    echo "}" >> env.json

    # now for code push:  the key in the plist is the test one, used for the app build by AppCenter on develop
    # when building on master we change to the live one
    # ios swap
    plutil -replace CodePushDeploymentKey -string "$CODEPUSH_KEY" ios/community/Info.plist
    # android swap : this is done in app/build.gradle using buildType
    # as noted above, the value is needed only for Android, and does not need to live in env.json. It is accessed directly by the build,gradle fie using System.getenv()

    # Now for Fabric and Crashlytics
    # iOS : note there is also a script inside the ios folder, which handles the init with the correct key
    # Here we just handle the plist value replacement
    /usr/libexec/PlistBuddy -c "Set :Fabric:APIKey $FABRIC_API_KEY" ios/community/Info.plist
    # Android : taken care of in buildType that each use a custom AndroidManifest with the correct key


else
    echo 'Setting staging env'

    # now for some manipulation of Firebase files. This script ensures that AppCenter will build using the DEV Firebase file on any branch other than "master"
    # this helps to ensure all test data is sent to the Firebase DEV account for any build executed on a branch other than master
    echo 'copying iOS Dev Firebase file into Prod folder, so analytics uses the Dev file'
    cp -rf "ios/Firebase/Dev/GoogleService-Info.plist" "ios/firebase/Prod"
    # For Android we don't really need this. AppCenter Develop buils using releaseStaging buildType, and that type already makes use of the dev file

fi