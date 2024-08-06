alias work='cd ~/Documents/work/'
alias pdp='cd ~/Documents/work/pdpipe_proj/pdpipe'
alias personal='cd ~/Documents/personal'
alias code='cd /Users/amihaio/Documents/work/code/voyantis'
alias code2='cd /Users/amihaio/Documents/work/code2/voyantis'
alias models='cd /Users/amihaio/Documents/work/vy-models'
alias ssh_ami='ssh -i ~/.ssh/NotebookServer.pem ubuntu@amihai-ds-notebook.voyantis.co'
# 'ssh -i ~/.ssh/NotebookServer.pem ubuntu@amihai-notebook.internal.voyantis.ai'
alias trans_conv='python3 /Users/amihaio/PycharmProjects/ynab_transactions_converter/main.py'
alias ip='curl ifconfig.me'
alias l='exa -lah --git --no-user --icons --group-directories-first'
alias instances='bat ~/extra/aws_instances'
alias bc='bat ~/byobu_cheat_sheet'
alias v='vim'
alias config='/usr/bin/git --git-dir=/Users/amihaio/.cfg/ --work-tree=/Users/amihaio'
alias dotfiles='cd ~/dotfiles'
alias cache='cd /Users/amihaio/Documents/work/cache'


voyantis_env_vars(){
    export PYTHONPATH=src
    export ENV_NAME=staging
    export STAGING_NAME=stagenv1
    export APP_NAME=$1
}


file_watch(){
	watch -n 0.2 cat $1
}

fp(){
  readlink -f $1
}

lsg(){
l | grep $1
}

lt(){
 exa -lahT -L $1 --git --icons --no-user --group-directories-first
}

print_csv(){
 column -s, -t < $1 | less -#5 -N -S    
}


dbt_run() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: [query model name] [customer] [product] [version]"
        return 0
    fi

    local param1="$2"
    local param2="$3"

    # Convert to uppercase
    p2=$(echo "$param2" | tr '[:lower:]' '[:upper:]')
    p3=$(echo "$param3" | tr '[:lower:]' '[:upper:]')

    export HTTPS_PROXY="http://snowflake-proxy.internal.voyantis.io:8448"
    dbt run -s $1 --vars '{"CUSTOMER_DWH":"CUSTOMER_PROD_$p2_$p3", "CUSTOMER_DL":"CUSTOMER_PROD_$p2_$p3", "CUSTOMER": "$p2", "PRODUCT": "$p3", "VERSION": $4}'
    unset HTTPS_PROXY
}

######################
## AWS EC2 commands ##
######################

export ami1="i-013cae967732eb308"
export datauploader="i-00afe9ad9d378444d"

source /Users/amihaio/Documents/work/change_ec2_instance_type.sh
ami_change() {
   change_ec2_instance_type -r -i $ami1 -t $1
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

scp_to_ami() {
    scp -i ~/.ssh/NotebookServer.pem $1 ubuntu@amihai-ds-notebook.voyantis.co:$2
}

scp_from_ami() {
    scp -i ~/.ssh/NotebookServer.pem ubuntu@amihai-ds-notebook.voyantis.co:$1 $2
}

scp_folder_from_ami() {
    scp -r -i ~/.ssh/NotebookServer.pem ubuntu@amihai-ds-notebook.voyantis.co:$1 $2
}

scp_folder_to_ami() {
    scp -r -i ~/.ssh/NotebookServer.pem $1 ubuntu@amihai-ds-notebook.voyantis.co:$2
}

