Sequence:
1. vagrant file: create VM and launch ansible file
2. ansible: in the VM install docker, build dockerfile image with jenkins, set the socket for docker in docker and start the container
3. jenkins: build the dockerimage in the home of this repository setting tags and push the image in the docker hub repository
