#!/usr/bin/env bash
set -e
set -x
echo "$APPCENTER_BRANCH"
if [ "$APPCENTER_BRANCH" == 'master' ]; then
# #here you can do stuff for master, like injecting keys, etc.
echo 'TODO'
else
echo 'copying iOS Dev Firebase file into Prod folder, so analytics uses the Dev file'
cp -rf "ios/Firebase/Dev/GoogleService-Info.plist" "ios/firebase/Prod"
# we do the same for Android
echo 'copying Android debug Firebase file into release folder, so analytics uses the Dev file'
cp -rf "android/app/src/debug/google-services.json" "android/app/src/release/google-services.json"
fi

if [ "$BUILD_ENVVAR" == 'production' ]; then
    echo 'Setting production env'
    cp -f "src/env.production.json" "src/env.json"
elif [ "$BUILD_ENVVAR" == 'staging' ]; then
    echo 'Setting staging env'
    cp -f "src/env.staging.json" "src/env.json"
fi