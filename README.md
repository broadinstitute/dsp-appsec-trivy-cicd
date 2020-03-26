Trivy is a vulnerability scanner for containers. Detects vulnerabilties in OS packages and application dependencies.
Before pushing an image to a container registry, scan with Trivy.  

### Test trivy in MacOS

Pull image: 

`docker pull aquasec/trivy`

Scan your image:

`docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy [YOUR_IMAGE_NAME]`

Show just critical and high vulnerabilities 

`docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy --severity HIGH,CRITICAL [YOUR_IMAGE_NAME]` 


## Setup Trivy in CI/CD tools 

<details>
  <summary>Github Actions</summary>

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

</details>

<details>
  <summary>Jenkins</summary>

</details>

<details>
  <summary>Travis</summary>

</details>


