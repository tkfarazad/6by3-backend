AWS_PROFILE := 6by3
STAGING_BRANCH := master
PRODUCTION_BRANCH := production
ANSIBLE_CONFIG := ansible/ansible.cfg

staging-release:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/release.yml -i ansible/staging --extra-vars "branch=${STAGING_BRANCH} aws_profile=${AWS_PROFILE}" -v

staging-initial-deploy:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/initial-deploy.yml -i ansible/staging --extra-vars "branch=${STAGING_BRANCH} aws_profile=${AWS_PROFILE}"-v

staging-deploy:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/deploy.yml -i ansible/staging --extra-vars "aws_profile=${AWS_PROFILE}" -v

staging-release-deploy:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/release-deploy.yml -i ansible/staging --extra-vars "branch=${STAGING_BRANCH} aws_profile=${AWS_PROFILE}" -v

staging-command:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/command.yml -i ansible/staging --extra-vars "aws_profile=${AWS_PROFILE}" -v

production-release:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/release.yml -i ansible/production--extra-vars "branch=${PRODUCTION_BRANCH} aws_profile=${AWS_PROFILE}" -v

production-initial-deploy:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/initial-deploy.yml -i ansible/production--extra-vars "branch=${PRODUCTION_BRANCH} aws_profile=${AWS_PROFILE}"-v

production-deploy:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/deploy.yml -i ansible/production--extra-vars "aws_profile=${AWS_PROFILE}" -v

production-release-deploy:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/release-deploy.yml -i ansible/production--extra-vars "branch=${PRODUCTION_BRANCH} aws_profile=${AWS_PROFILE}" -v

production-command:
	ANSIBLE_CONFIG=${ANSIBLE_CONFIG} ansible-playbook ansible/command.yml -i ansible/production--extra-vars "aws_profile=${AWS_PROFILE}" -v
