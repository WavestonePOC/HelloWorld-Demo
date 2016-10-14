oc project $DEVEL_PROJ_NAME

#Is this a new deployment or an existing app? Decide based on whether the project is empty or not
#If BuildConfig exists, assume that the app is already deployed and we need a rebuild

BUILD_CONFIG=$BUILD_CONFIG

if [ $BUILD_CONFIG == 0 ]; then

# no app found so create a new one
  echo "Create a new app"
  oc new-app --template=helloworld-php-pgsql

  echo "Find build id"
  BUILD_ID=`oc get builds | tail -1 | awk '{print $1}'`
  rc=1
  attempts=75
  count=0
  while [ $rc -ne 0 -a $count -lt $attempts ]; do
    BUILD_ID=`oc get builds | tail -1 | awk '{print $1}'`
    if [ $BUILD_ID == "NAME" ]; then
      count=$(($count+1))
      echo "Attempt $count/$attempts"
      sleep 5
    else
      rc=0
      echo "Build Id is :" ${BUILD_ID}
    fi
  done

  if [ $rc -ne 0 ]; then
    echo "Fail: Build could not be found after maximum attempts"
    exit 1
  fi
else

  # Application already exists, just need to start a new build
  echo "App Exists. Triggering application build and deployment"
  BUILD_ID=`oc start-build ${BUILD_CONFIG}`

fi

echo "Waiting for build to start"
rc=1
attempts=25
count=0
while [ $rc -ne 0 -a $count -lt $attempts ]; do
  status=`oc get build ${BUILD_ID} -t '{{.status.phase}}'`
  if [[ $status == "Failed" || $status == "Error" || $status == "Canceled" ]]; then
    echo "Fail: Build completed with unsuccessful status: ${status}"
    exit 1
  fi
  if [ $status == "Complete" ]; then
    echo "Build completed successfully, will test deployment next"
    rc=0
  fi

  if [ $status == "Running" ]; then
    echo "Build started"
    rc=0
  fi

  if [ $status == "Pending" ]; then
    count=$(($count+1))
    echo "Attempt $count/$attempts"
    sleep 5
  fi
done

# stream the logs for the build that just started
oc logs build/$BUILD_ID



echo "Checking build result status"
rc=1
count=0
attempts=100
while [ $rc -ne 0 -a $count -lt $attempts ]; do
  status=`oc get build ${BUILD_ID} --template '{{.status.phase}}'`
  if [[ $status == "Failed" || $status == "Error" || $status == "Canceled" ]]; then
    echo "Fail: Build completed with unsuccessful status: ${status}"
    exit 1
  fi

  if [ $status == "Complete" ]; then
    echo "Build completed successfully, will test deployment next"
    rc=0
  else
    count=$(($count+1))
    echo "Attempt $count/$attempts"
    sleep 5
  fi
done

if [ $rc -ne 0 ]; then
    echo "Fail: Build did not complete in a reasonable period of time"
    exit 1
fi


echo "Checking build result status"
rc=1
count=0
attempts=200
while [ $rc -ne 0 -a $count -lt $attempts ]; do
  status=`oc get build ${BUILD_ID} --template '{{.status.phase}}'`
  if [[ $status == "Failed" || $status == "Error" || $status == "Canceled" ]]; then
    echo "Fail: Build completed with unsuccessful status: ${status}"
    exit 1
  fi

  if [ $status == "Complete" ]; then
    echo "Build completed successfully, will test deployment next"
    rc=0
  else
    count=$(($count+1))
    echo "Attempt $count/$attempts"
    sleep 5
  fi
done

if [ $rc -ne 0 ]; then
    echo "Fail: Build did not complete in a reasonable period of time"
    exit 1
fi

# scale up the test deployment
RC_ID=`oc get rc | tail -1 | awk '{print $1}'`

echo "Scaling up new deployment $test_rc_id"
oc scale --replicas=1 rc $RC_ID


echo "Checking for successful test deployment at $HOSTNAME"
set +e
rc=1
count=0
attempts=200
while [ $rc -ne 0 -a $count -lt $attempts ]; do
  if curl -s --connect-timeout 2 $APP_HOSTNAME >& /dev/null; then
    rc=0
    break
  fi
  count=$(($count+1))
  echo "Attempt $count/$attempts"
  sleep 5
done
set -e

if [ $rc -ne 0 ]; then
    echo "Failed to access test deployment, aborting roll out."
    exit 1
fi


################################################################################
##Include development test scripts here and fail with exit 1 if the tests fail##
################################################################################
