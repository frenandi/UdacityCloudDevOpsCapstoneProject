/home/ubuntu/kubectl apply -f $1

/home/ubuntu/kubectl set image deployments/$2 $3=$4

/home/ubuntu/kubectl describe services $5

/home/ubuntu/kubectl rollout status deployments/$2