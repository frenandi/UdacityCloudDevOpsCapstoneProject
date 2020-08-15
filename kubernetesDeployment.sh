/home/ubuntu/kubectlkubectl apply -f $1

/home/ubuntu/kubectlkubectl set image deployments/$2 $3=$4

/home/ubuntu/kubectlkubectl expose deployment/$2 \
--name=$5 \
--type="LoadBalancer" \
--port=$6 \
--target-port=$7

/home/ubuntu/kubectlkubectl describe services $5