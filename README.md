Trivy is an image vulnerability scanner. Detects vulnerabilties in OS packages and application dependencies.
Before pushing an image to a container registry, scan with Trivy.  

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


## Setup Trivy in CI/CD tools 

<details>
  <summary>Github Actions</summary>

#### Github Actions

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

Job will fail when critical and high vulnerabilties are found, if one of the options is used:

- `args: --exit-code 1 --severity CRITICAL,HIGH --no-progress us.gcr.io/${GOOGLE_PROJECT}/${YOUR_IMAGE}` 
- `args: --exit-code 0 --severity MEDIUM,LOW --no-progress us.gcr.io/${GOOGLE_PROJECT}/${YOUR_IMAGE}`

</details>

<details>
  <summary>CircleCI</summary>

#### CircleCI

  `.circleci` folder has 2 workflows: 
   - `config_test_only.yml` worlkflow builds and scans an image
   - `config.yml` workflow builds scans image with TRIVY and push the image in GCR if scan doesn't exit with `--exit-code 1 ` 

Setup circleCi project to push an image in GCR:
 - Create a service account
 - Generated private key in JSON format
 - Create an environment variable in CircleCI project, name it `GOOGLE_AUTH` and include private key in Json format.  


</details>


<details>
  <summary>Travis</summary>

#### Travis

`travis.yml` builds an image and scans it with Trivy.

Workflow will fail if there are critical vulnerabilities found by Trivy. 


</details>




