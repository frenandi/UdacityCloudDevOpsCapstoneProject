kubectl apply -f $1

kubectl set image deployments/$2 $3=$4

kubectl expose deployment/$2 \
--name=$5 \
--type="LoadBalancer" \
--port=$6
--target-port=$7

kubectl describe services $5