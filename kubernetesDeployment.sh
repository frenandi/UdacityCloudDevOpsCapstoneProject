/home/ubuntu/kubectl apply -f $1



/home/ubuntu/kubectl expose deployment/$2 \
--name=$5 \
--type="LoadBalancer" \
--port=$6 \
--target-port=$7

/home/ubuntu/kubectl describe services $5