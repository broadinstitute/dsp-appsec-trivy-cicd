set -eu

if [[  -z "${1+set}" ]]; then
    echo "Please enter docker IMAGE NAME" ;
    echo "Example: sh build_scan_push.sh YOUR_IMAGE_NAME"  
else 
    image="$1"
    project=$( gcloud config get-value project)
    tag="latest"

    echo "Building image ..."
    docker build -t $image:latest . 

    docker tag $image:$tag us.gcr.io/$project/$image:$tag

    echo "Scanning image ..."
    docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy  --exit-code 1 --severity CRITICAL us.gcr.io/$project/$image:$tag

    echo "Pushing image to GCR ..."
    gcloud docker -- push us.gcr.io/$project/$image:$tag
fi
