Creare Dockerfile app di esempio Flask (Python) che esponga una pagina avente stringa "hello world" (prendere spunto da qui: https://github.com/docker/awesome-compose/tree/master/flask/app)

Scrivere pipeline dichiarativa Jenkins che effettui una build dell'immagine Docker e che effettui il push sul proprio account DockerHub.  
La pipeline Jenkins deve chiamarsi flask-app-example-build. Il tag dell'immagine Docker deve essere uguale al tag git se "buildata" da tag git, latest se "buildata" da branch master, uguale  a "develop + sha comit GIT" se "buildata" da branch develop.

1. Creo il Dockerfile per creare un'immagine docker "hello world" (https://github.com/federicopao/formazione_sou_k8s/Dockerfile)
2. Utilizzo Vagrant per tirare su una macchina virtuale che configuro con Ansible
3. Dentro la vm buildo un container con l'immagine di jenkins, jenkins deve poter buildare un'immagine docker per fare ciò ho la
   necessità che all'interno del container possano essere eseguito comandi docker, personalizzo quindi l'immagine docker di Jenkins
   per installare docker (https://github.com/federicopao/formazione_sou_k8s/JenkinsDocker/Dockerfile)
   ```
   FROM jenkins/jenkins

   USER root
  
   RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*
   RUN usermod -aG docker jenkins
  
   USER jenkins
   ```
4. Nel playbook di Ansible copio l'immagine personalizzata di Jenkins nella vm per fare il build dell'immagine
   ```
   - name: "Copy image in VM for build"
     ansible.builtin.template:
       src: /Users/federico/desktop/vagrantm1/formazione_sou_k8s/JenkinsDocker/Dockerfile
       dest: ./
       owner: vagrant
       group: vagrant
       mode: "0740"
   ```
5. Creo il container passandogli il docker socket della vm, impostando le porte e settando i permessi (i gruppi relativi ai permessi
   sono stati settati nel dockerfile: RUN usermod -aG docker jenkins)
   ```
   - name: Create container
     docker_container:
       name: container
       state: started
       image: dockerfile
       ports:
        - "8080:8080"
        - "50000:50000"
       volumes:
        - /var/run/docker.sock:/var/run/docker.sock

   - name: Permission for docker socket
     ansible.builtin.shell:
       cmd: sudo -i docker exec -it --user root container bash -c 'cd /var/run && chgrp docker docker.sock'
   ```
6. Ora possiamo fare il "vagrant up" per avviare la vm e le configurazioni del file di ansible
7. Inserendo l'ip del vm e la porta 8080 nel browser possiamo connetterci alla dashboard di Jenkins in modo da poter definire la
   pipeline. Inserisco le credenziali di dockerhub in Jenkins tramite la dashboard, creo un job di tipo "pipeline multibranch"
   (ci permette di lavorare con repo di git multibranch, ogni branch o tag deve contenere un Jenkinsfile) e gli passo la repository
   di git per passargli la pipeline nel Jenkinsfile
8. La pipeline deve effettuare 3 operazioni:
   - buildare l'immagine con flask
     ```
     sh 'docker build -t federicopao/formazione_sou_k8s:VERSIONE
     ```
   - accedere al dockerhub
     ```
     withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
              sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
     }
     ```
   - fare il push
     ```
     sh 'docker push federicopao/formazione_sou_k8s:VERSIONE
     ```
9. Dobbiamo però dare la versione in base al branch o al tag, per questo usiamo un if
   ```
   if (env.BRANCH_NAME == 'main') {
            sh 'docker build -t federicopao/formazione_sou_k8s:latest .'
          } else if (env.BRANCH_NAME == 'develop') {
            sh 'docker build -t federicopao/formazione_sou_k8s:prova .'
          } else {
            sh 'docker build -t federicopao/formazione_sou_k8s:$TAG_NAME .'
          }
   ```
10. Possiamo ora eseguire la pipeline
