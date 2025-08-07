
add_batch_job(){
    # arg1 - job id
    # arg2 - job name
    local arg1="$1"
    local arg2="$2"

    local file="/Users/amihaio/Documents/work/aws_batch_status_checker/jobs.txt" 

    echo "$arg1 $arg2" >> "$file"

}


######################
## AWS EC2 commands ##
######################

export ami1="i-013cae967732eb308"
export datauploader="i-00afe9ad9d378444d"

source $HOME/change_ec2_instance_type.sh
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

