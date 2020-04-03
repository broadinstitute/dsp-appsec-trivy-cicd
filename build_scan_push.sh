set -eu

if [[  -z "${1+set}" ]]; then
    echo "Please enter docker IMAGE NAME" ;
    echo "Example: sh build_scan_push.sh YOUR_IMAGE_NAME"  1>&2
else 
    image="$1"
    project=$( gcloud config get-value project)
    tag="latest"
    gcloud_registry="us.gcr.io"

    echo "Building image ..."
    docker build -t $image:latest . 

    docker tag $image:$tag $gcloud_registry/$project/$image:$tag

    echo "Scanning image ..."
    docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy  --exit-code 1 --severity CRITICAL $gcloud_registry/$project/$image:$tag

    echo "Pushing image to GCR ..."
    gcloud docker -- push $gcloud_registry/$project/$image:$tag
fi
