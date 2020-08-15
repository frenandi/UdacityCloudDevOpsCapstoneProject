/home/ubuntu/kubectl apply -f file://$1

/home/ubuntu/kubectl set image deployments/$2 $3=$4

/home/ubuntu/kubectl expose deployment/$2 \
--name=$5 \
--type="LoadBalancer" \
--port=$6 \
--target-port=$7

/home/ubuntu/kubectl describe services $5