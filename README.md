# Trivy setup in CI/CD
A vulnerability scanner for conatiners. Detects vulnerabilties in OS packages and application dependencies. Before pushing an image to a container registry, scan with Trivy.  

### Test trivy in MacOS

Pull image: 

`docker pull aquasec/trivy`

Scan your image:

`docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy ${YOUR_IMAGE}`

Show just critical and high vulnerabilities 

`docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy --severity HIGH,CRITICAL ${YOUR_IMAGE}` 

## Setup Trivy in CI/CD tools 


<details>
  <summary>Github Actions</summary>

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


