alias work='cd ~/Documents/work/'
alias personal='cd ~/Documents/personal'
alias code='cd /Users/amihaio/Documents/work/code/voyantis'
alias code2='cd /Users/amihaio/Documents/work/code2/voyantis'
alias models='cd /Users/amihaio/Documents/work/vy-models'
alias ssh_ami='ssh -i ~/.ssh/NotebookServer.pem ubuntu@amihai-1.internal.voyantis.ai'
alias trans_conv='python3 /Users/amihaio/PycharmProjects/ynab_transactions_converter/main.py'
alias ip='curl ifconfig.me'
alias l='exa -lah --git --no-user --icons --group-directories-first'

lsg(){
ls | grep $1
}

lt(){
 exa -lahT -L $1 --git --icons --no-user --group-directories-first
}

#########################
## AWS security groups ##
#########################

add_home_ip(){
	aws ec2 authorize-security-group-ingress \
    --group-name notebook-server \
    --ip-permissions IpProtocol=tcp,FromPort=$2,ToPort=$2,IpRanges="[{CidrIp=$1/32,Description='Amihai home'}]" \
    --tag-specifications ResourceType='security-group-rule',"Tags"="[{"Key"="id", "Value"="amihai"}]"
}

add_home_ips(){
    ip=`curl -s ifconfig.me`
	add_home_ip $ip 22
	add_home_ip $ip 9997
}

remove_home_ips(){
  ids=$(aws ec2 describe-security-group-rules  --filters "Name=tag-value,Values=amihai")
  echo $ids | grep "CidrI" | awk -F '"' '{print $4}' | while read -r line; do remove_home_ips_helper $line; done
}

remove_ip(){
	aws ec2 revoke-security-group-ingress \
    --group-name notebook-server \
    --protocol tcp \
    --port $2 \
    --cidr $1
}

remove_home_ips_helper(){
	remove_ip $1 22
	remove_ip $1 9997
}

remove_and_add_ip(){
  remove_home_ips
  add_home_ips
 }

######################
## AWS EC2 commands ##
######################

export ami1="i-083cc858c4373aaf6"
export datauploader="i-00afe9ad9d378444d"

source /Users/amihaio/Documents/work/change_ec2_instance_type.sh
ami_change() {
   change_ec2_instance_type -i $ami1 -t $1
}

ami_start() {
    aws ec2 start-instances --instance-ids $ami1
}

ami_stop() {
    aws ec2 stop-instances --instance-ids $ami1
}

ami_status(){
    aws ec2 describe-instance-status --instance-id $ami1
}

scp_to_notebook() {
    scp -i ~/.ssh/NotebookServer.pem $1 ubuntu@notebook.internal.voyantis.ai:$2
}

scp_to_ami() {
    scp -i ~/.ssh/NotebookServer.pem $1 ubuntu@amihai-1.internal.voyantis.ai:$2
}

scp_from_ami() {
    scp -i ~/.ssh/NotebookServer.pem ubuntu@amihai-1.internal.voyantis.ai:$1 $2
}

scp_folder_from_ami() {
    scp -r -i ~/.ssh/NotebookServer.pem ubuntu@amihai-1.internal.voyantis.ai:$1 $2
}

scp_folder_to_ami() {
    scp -r -i ~/.ssh/NotebookServer.pem $1 ubuntu@amihai-1.internal.voyantis.ai:$2
}

alias config='/usr/bin/git --git-dir=/Users/amihaio/.cfg/ --work-tree=/Users/amihaio'
