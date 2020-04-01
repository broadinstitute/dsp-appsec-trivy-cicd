set -eu


if [[  -z "${1+set}" ]]; then
    echo "Please enter docker image name" ;
    echo "Example: sh build_scan_push.sh YOUR_IMAGE_NAME"  
else 
    image="$1"

    echo "Building image ..."
    docker build -t us.gcr.io/${GOOGLE_PROJECT}/$image:latest . 

    echo "Scanning image ..."
    docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy  --exit-code 1 --severity CRITICAL,HIGH us.gcr.io/${GOOGLE_PROJECT}/$image:latest 

    echo "Pushing image to GCR ..."
    gcloud docker -- push us.gcr.io/${GOOGLE_PROJECT}/$image:latest 
fi