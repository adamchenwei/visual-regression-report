#### CHECKOUT BRANCH
echo '-------------------------------ooooooooo'

echo '-------------------------------dir beg'
ls -lA
echo '-------------------------------dir end'

echo "Running against ${bamboo_TARGET_HOST}"

git remote set-url origin git@github.com:Chewy-Inc/storefront.git
git fetch --quiet --all
git checkout feature/SFW-9301-visual-regression-app

echo '-------------------------------AFTER CHECKOUT my branch'

echo '-------------------------------dir beg'
ls -lA
echo '-------------------------------dir end'

echo '-------------------------------NEXT NPM!!!!'




#### NPM AND Node Information BEG
#### NPM AND Node Information BEG
echo 'NPM AND Node Information BEG'

echo 'NPM AND Node Information PWD'
pwd





echo '-------------- node and npm info vvvvvvvv --------'
node -v
npm -v

which node

which npm

echo "Pre sourcing"
which npm
source /opt/rh/rh-nodejs8/enable
echo "Post sourcing"

echo "NPM ---"
npm -v
which npm
echo "NODE ---"
node -v
which node

echo '-------------------------------bamboo env var beg'
echo "vvvvv all dirs BEG vvvvv"
ls -lA
echo "vvvvv all dirs END vvvvv"


echo "vvvv deploymentResultId "
echo deploymentResultId
echo "^^^^ deploymentResultId "


echo "vvvvv all ENVS BEG vvvvv"
printenv
echo "vvvvv all ENVS END vvvvv"
echo "v bamboo_TARGET_HOST v"
echo "$bamboo_TARGET_HOST"
echo "^ bamboo_TARGET_HOST ^"
echo '-------------------------------bamboo env var end'

echo '-------------- node and npm info ^^^^^^^^ --------'




echo '-------------- NPM START vvvvvvvv --------'

cd visual-regression-app && npm install && npm run test --ci --env-ref-site='http://'"$bamboo_TARGET_HOST"'' --env-ref-aws-access-key="$bamboo_RELENG_AWS_ACCESS_PASSWORD"  --env-ref-aws-access-secret="$bamboo_RELENG_AWS_SECRET_PASSWORD"
#NOTE: CRITICAL, this MUST EXECUTE RIGHT AFTER ABOVE COMMAND TO RECEIVE CORRECT status number 1 or 0
echo $? >> ./../jestExecutionResult
echo '---- vv EXIST STATUS prev task post jest 2 BEG---'

echo '---- vv EXIST STATUS prev task jest 2 END---'
echo '-------------- CMD 1 BEG vvvvvvvv --------'
pwd
echo '-------------- CMD 1 RUNNING BEG --------'

echo '-------------- CMD 1 RUNNING END --------'
pwd
jestExecutionResult=$(cat ./../jestExecutionResult)
echo $jestExecutionResult



echo '--- REPORT_DIR'
REPORT_DIR=`echo $bamboo_resultsUrl | cut -d"?" -f2 | cut -d"=" -f2`
echo REPORT_DIR
echo '-------------- CMD 1 END vvvvvvvv --------'

echo '-------------- Git stuff 1.1 START vvvvvvvv --------'

if [[ $jestExecutionResult -eq 1 ]]; then
  echo '-----OK LETS UPDATE SNAPSHOTS-----'
  npm run test -u
else
  echo '--- everything passed NOTHING TO UPDATE!---'
fi

pwd
git status
git branch
git checkout -b feature/update-snapshot-$REPORT_DIR
git add src/*
git branch
git status
git commit -m "test(snapshot): update for SFW-xxx" -n
git push origin feature/update-snapshot-$REPORT_DIR
echo "feature/update-snapshot-$REPORT_DIR" >> ./../snapshotUpdateBranchName
snapshotUpdateBranchName=$(cat ./../snapshotUpdateBranchName)

echo '-------------- Git stuff 1.1 END vvvvvvvv --------'

#### NPM AND Node Information BEG





#### Save Snapshots As Reporter BEG
#### Save Snapshots As Reporter BEG
echo 'Save Snapshots As Reporter BEG'
pwd



echo '--- SSAR dir 1'
ls $bamboo_build_working_directory/visual-regression-app/src/__image_snapshots__/
echo '--- SSAR dir 2'
ls $bamboo_build_working_directory/visual-regression-app
echo '--- SSAR dir 3'
ls $bamboo_build_working_directory
echo '--- SSAR dir 4'
ls

echo '-------------- AWS START vvvvvvvv --------'
export AWS_ACCESS_KEY_ID=${bamboo_RELENG_AWS_ACCESS_PASSWORD}
export AWS_SECRET_ACCESS_KEY=${bamboo_RELENG_AWS_SECRET_PASSWORD}
export AWS_REGION=us-east-2
export PRESIGN_EXPIRATION_SECONDS=604800 # 604800 sec / 7 days is max

echo '-------------- SNAPSHOT DIR BEG 1 --------'
ls $bamboo_build_working_directory
echo '-------------- SNAPSHOT DIR END 1 --------'


echo "bamboo_planRepository_1_revision vvv"
echo $bamboo_planRepository_1_revision
ls $bamboo_build_working_directory/visual-regression-app
REPORT_DIR=`echo $bamboo_resultsUrl | cut -d"?" -f2 | cut -d"=" -f2`
aws s3 cp $bamboo_build_working_directory/visual-regression-app/reporter.html s3://sfw-pixel-snapshots/$REPORT_DIR/reporter.html
echo $(aws s3 presign  s3://sfw-pixel-snapshots/$REPORT_DIR/reporter.html --expires-in=${PRESIGN_EXPIRATION_SECONDS}
) > ../awsReportUrl
$awsReportUrl = $(cat ../awsReportUrl);

awsReportUrl=$(aws s3 presign  s3://sfw-pixel-snapshots/$REPORT_DIR/reporter.html --expires-in=${PRESIGN_EXPIRATION_SECONDS})
echo 'awsReportUrl vvvv'
echo $awsReportUrl

# aws s3 cp $bamboo_build_working_directory/visual-regression-app/src/dummy/index.html s3://sfw-pixel-snapshots/reporter/index.html
# aws s3 presign s3://sfw-pixel-snapshots/reporter/index.html --expires-in=${PRESIGN_EXPIRATION_SECONDS}
echo '-------------- AWS END ^^^^^^^^ --------'


echo '-------------- Git stuff START vvvvvvvv --------'
echo 'into storefront'
cd storefront
ls
echo 'into visual app'
cd visual-regression-app
ls

git status
git branch
git checkout -b feature/update-snapshot-$REPORT_DIR



echo '-------------- Git stuff END vvvvvvvv --------'


echo '-------------- PR START vvvvvvvv --------'
# snapshotUpdateBranchName
snapshotUpdateBranchName=$(cat ../snapshotUpdateBranchName)
echo $snapshotUpdateBranchName
# curl -H "Authorization: token $bamboo_chewbot_github_token_password" --header "Content-Type: application/json" --request POST --data '{"title": "Test Test Test","body": "Please ignore this test PR!","head": "'$snapshotUpdateBranchName'","base": "master"}' https://api.github.com/repos/Chewy-Inc/storefront/pulls



## DISABLED vvv

prData="$(curl -H "Authorization: token $bamboo_chewbot_github_token_password" --header "Content-Type: application/json" --request POST --data '{"title": "Test Test Test","body": "Please ignore this test PR! here is the link to see image diff report '$awsReportUrl'","head": "'$snapshotUpdateBranchName'","base": "feature/SFW-9301-visual-regression-app"}' https://api.github.com/repos/Chewy-Inc/storefront/pulls
)"
echo 'prData vvv'
echo $prData

## DISABLED ^^^



echo '-------------- PR END ^^^^^^^^ --------'


echo '-------------- CMD 1.2 BEG vvvvvvvv --------'
pwd


snapshotUpdateBranchName=$(cat ../snapshotUpdateBranchName)
echo $snapshotUpdateBranchName


ls -lA

echo '-------------- CMD 1.2 END vvvvvvvv --------'





echo 'Save Snapshots As Reporter END'

#### Save Snapshots As Reporter


#### Save Snapshots As Reporter END


#### report devenv status to github BEG
echo 'report devenv status to github PWD'
pwd
echo 'report devenv status to github ls prev dir 1'
ls ./../

echo 'report devenv status to github ls prev dir 2'
ls ~

echo 'report devenv status to github ls prev dir 3'
ls ~/../

echo 'report devenv status to github ls prev dir 4'
ls ./../../

echo 'report devenv status to github ls prev dir 5'
ls ~/../../

echo '-------------- CMD 3 BEG vvvvvvvv --------'
ls -lA
jestExecutionResult=$(cat ./../jestExecutionResult)
echo $jestExecutionResult

awsReportUrl=$(cat ./../awsReportUrl)
echo $awsReportUrl
echo '-------------- CMD 3 END vvvvvvvv --------'

echo '-------------------------------END OF NPM STUFF'
echo '-------------------------------yyyyyyyy'


echo '---- vv CMD 2 BEG---'
echo $jestExecutionResult
echo '---- vv CMD 2 END---'
org_repo=$(echo ${bamboo.planRepository.repositoryUrl} | sed s~https://github.com/~~ | sed s/.git//)
revision=${bamboo.planRepository.1.revision}

if [[ $jestExecutionResult -eq 0 ]]; then
  build_state="success"
  build_state_desc="OH NICE PASSED!"
else
  build_state="failure"
  build_state_desc="Oh nooo ...."
fi

build_state_2="failure"
build_state_desc_2="Oh nooooooooo VISUAL REGRESSION T_T"

curl -v -H "Authorization: token ${bamboo.repo_status_password}" https://api.github.com/repos/${org_repo}/statuses/${revision} --data "{\"state\": \"${build_state}\",\"target_url\": \"${bamboo_resultsUrl}\",\"description\": \"${build_state_desc}\",\"context\": \"ci/bamboo\"}"

curl -v -H "Authorization: token ${bamboo.repo_status_password}" https://api.github.com/repos/${org_repo}/statuses/${revision} --data "{\"state\": \"${build_state_2}\",\"target_url\": \"${awsReportUrl}\",\"description\": \"${build_state_desc_2}\",\"context\": \"ci/visualregression\"}"



echo 'end of everything...'
#### report devenv status to github END
