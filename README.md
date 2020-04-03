## Setup Trivy in CI/CD tools 

Trivy is an image vulnerability scanner. It detects vulnerabilties in OS packages and application dependencies. 
  

### Test trivy in MacOS 


Pull image: 

```
docker pull aquasec/trivy
```

Scan your image:

```
docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy [YOUR_IMAGE_NAME]
```

Show just critical and high vulnerabilities 

```
docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy --severity HIGH,CRITICAL [YOUR_IMAGE_NAME]
``` 



### Github Actions

 There are two workflows in `.github/workflows` folder:

   - `scan.yml` workflow builds and scans an image.
   - `scan_and_push.yml` workflow builds, scans and pushes an image in Google Container Registry. 
 
 When using `scan_and_push.yml` please make sure you have setup Google Container Registry.
- Create a Service Account
- Add the Cloud Build Service Account role to this Service Account
- Generate a key for this Service Account
- Create a SECRET in your repository named `GCLOUD_SERVICE_ACCOUNT_KEY` with the value of :
  
  -  `cat path-to/key.json | base64 -b 0` for MacOS 

  -  `cat path-to/key.json | base64 -w 0` for Linux 

- Create a SECRET in your repository named `YOUR_GOOGLE_PROJECT` with the value of your Google project-id. 

Job will fail when critical and high vulnerabilties are found, if one of the options is used:

- `args: --exit-code 1 --severity CRITICAL,HIGH --no-progress us.gcr.io/${GOOGLE_PROJECT}/${YOUR_IMAGE}` 
- `args: --exit-code 0 --severity MEDIUM,LOW --no-progress us.gcr.io/${GOOGLE_PROJECT}/${YOUR_IMAGE}`



### CircleCI

  `.circleci` folder has 2 workflows: 
   - `config_test_only.yml` worlkflow builds and scans an image.
   - `config.yml` workflow builds, scans the image with TRIVY and push that image in GCR if scan doesn't exit with `--exit-code 1 `.

Setup circleCi project to push an image in GCR:
 - Create a service account
 - Generated private key in JSON format
 - Create an environment variable in CircleCI project, name it `GOOGLE_AUTH` and include private key in Json format.  
 - Create an environement variable in CircleCI project, name it `YOUR_GOOGLE_PROJECT` and include your Google project id value 



### Travis

`travis.yml` builds an image and scans it with Trivy.

Workflow will fail if there are critical vulnerabilities found by Trivy. 



### Mark a vulnerability as false positive (FP)

- Create a file `.trivyignore`.
- Add `VULNERABILITY ID` of the vulnerability you want to mark as FP and comment the reason. 

 ```
 #  This vulnerability doesn't have impact in our settings
CVE-2019-18276

#  This vulnerability doesn't have impact in our settings too
CVE-2016-2779 
 ```






