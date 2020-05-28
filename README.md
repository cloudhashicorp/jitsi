# jitsi

[![IMAGE ALT TEXT](http://img.youtube.com/vi/8KR0AhDZF2A/0.jpg)](http://www.youtube.com/watch?v=8KR0AhDZF2A "Jitsi Meet Quick Installation Tutorial")

https://youtu.be/8KR0AhDZF2A


In the current situation, remote interaction is very important. As we are trying to adjust to a new norm whether in our profesional or personal life, technology plays a vital role. There are many commercially available Video Conference tool that an organization can use like Zoom Webex, 8x8, and many more. We can't deny the cost of subscription will be high for any organization and even individual who is trying to reach a person. To help the community in any possible way, I created this Terraform script which is a two-tiered architecture that will provision the needed infrastructure in AWS for the open source video conferencing tool called Jitsi. 

Introducing Jitsi
Jitsi is an open source web conference application built using JavaScript. You might find this useful if you are looking for tools to help you and your teams as you work remotely. You can check out the project on the Jitsi GitHub repository, but this tutorial will enable you to host your own version of this application. I will help you through installing this project on Amazon Web Services (AWS) and you should be able to deploy this to any AWS region nearest to you and the users you want to communicate with.

Deploying Jitsi on Amazon EC2
Prerequisites
You will need the following to complete this tutorial:

AWS Account: You will be configuring services, so you need an account with a user that can provision those services.
DNS provider: You will need to register your application via DNS as this is needed to obtain an SSL certificate. You can use Amazon Route 53 or other DNS providers.
Note: If you do not use DNS, you will be able to get Jitsi up and running, but you will then have to deal with potential issues with your users having SSL errors in the browser, as well as issues with the webcam and microphone not working.

Provision your Amazon EC2 instance
First you must create a running Linux instance on which to run your Jitsi server.

1. SSH keypair

Optional: If you already have SSH key pairs, you can use an existing one.

Create a key pair that you will use to SSH into your Jitsi server. From the EC2 console, on the left-hand side, click on Key Pairs and then use the Create button to create a PEM (default option) key pair.

Note: If you are using Windows, and likely using Putty, use the ppk key format.

Click on the Create Key Pair button and then make sure you save the key that pops up on your machine. Keep this safe. You will need to change the permissions of this file

Tip: Key pairs are regional, so make sure you match up the key pair you generate with the region you are going to launch your EC2 instances into.

This is important: Secure access to your EC2 instance. Make sure that you do not open up port ssh (22) to the world. Either limit it just to your IP address, or better still, use an existing bastion or jump host you have set up to do this. If you are not sure about this, then ask via the comments below and I will walk you through this.

2. Launch instance
Before launching the instance, you must think about the instance type you want to select and how much this will cost. Jitsi needs a fair bit of memory, so using the micro instances will not work without tuning/hacking, which is outside the scope of this article.

As a minimum, I would go for 1 CPU and 8GB of memory, but you can go with AMD instances. I have not tried Graviton ARM-based instances, but that will be something to try—it all depends on whether the application binaries have been compiled for ARM and are in the application repositories. If you try this, let me know.

In this tutorial, I use the t3.large instances; these provide 2vCPUs and 8GB of memory, which should support a small number of people using this. You might want to consider a couple of things when sizing your instances:

the CPU/Memory combinations increasing with the number of users, and
the network performance.
The T instances have 5 Gbps, but you might get much better performance with the other instances types that go up to 25 Gbps.

Tip: When looking at sizing options, network performance and memory are the two key parameters to prioritize.

Note: You may clone this repo https://github.com/cloudhashicorp/jitsi that will provision the EC2 instances, Application Load Balancer
      and Auto Scaling Group that will save you time and start the installation in the instances.

Set up your DNS
This step is optional, but highly recommended. You can proceed without DNS, and you will configure your Jitsi server to use an IP address when accessing it. However, you will not be able to configure SSL certs successfully and your users may experience usability/browser issues when connecting.

You will need to configure a DNS entry for the new host you have provisioned, so that it can be used to generate the SSL certificates as part of the installation process.

Note: The LetsEncrypt script will do a reverse lookup and expect to resolve the name of this host from the IP. The process also expects this to be an A record. I have not tried to see what happens if you use an Alias or C record.

Before proceeding, make sure that when you do a, nslookup—or whatever your preferred DNS lookup tool might be—that the DNS record you created now resolves to the instance IP address. Do not proceed until this is the case.

Install and configure Jitsi
We can now being the business of installing and configuring Jitsi. ssh into your instance. You will use the SSH key to do this and your command will be something like:

ssh -i {ssh-key} ubuntu@{ip address}

Where the {ssh-key} is the key you created, the the {ip-address} is the IP address of the instance that you launched. If you get a hang during this operation, you should check your security groups and your IP address as it is likely that your ssh is being blocked.

$ sudo su -
# echo 'deb https://download.jitsi.org stable/' >> /etc/apt/sources.list.d/jitsi-stable.list
# wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -
# apt-get update

Updating all the local packages will take a few seconds or minutes. Once this has completed, make changes to your system.conf file to accommodate the needs of this application.

To update the values, edit /etc/systemd/system.conf with your favorite editor (mine is vi):

# vi /etc/systemd/system.conf

Make sure you have the following values; you can either and comment them in the file, or just add these to the end of the file, which I find easier to do:

DefaultLimitNOFILE=65000
DefaultLimitNPROC=65000
DefaultTasksMax=65000

You will now need to reload the systemd to incorporate these changes, so run the following command:

# systemctl daemon-reload

Now install the Jitsi application using the following command:

# apt-get -y install jitsi-meet

This should take about a minute, then you will be prompted with a nice pink screen to enter the hostname of the current installation. This is where you enter the DNS name you registered and now resolves to the host IP.

Once you have entered that, it will ask whether you want to generate certificates or use existing ones. For this part, select the default option of generate certificates.

The installation process should complete after you hit Return, which will not take more than a couple of minutes. Output similar to the following will be displayed:

Replacing debian:VeriSign_Universal_Root_Certification_Authority.pem
Replacing debian:Verisign_Class_3_Public_Primary_Certification_Authority_-_G3.pem
Replacing debian:Visa_eCommerce_Root.pem
Replacing debian:XRamp_Global_CA_Root.pem
Replacing debian:certSIGN_ROOT_CA.pem
Replacing debian:ePKI_Root_Certification_Authority.pem
Replacing debian:thawte_Primary_Root_CA.pem
Replacing debian:thawte_Primary_Root_CA_-_G2.pem
Replacing debian:thawte_Primary_Root_CA_-_G3.pem
Adding debian:auth.jitsi.beachgeek.co.uk.pem 
done.
done.
Setting up jitsi-meet (1.0.4101-1) ...
Processing triggers for systemd (237-3ubuntu10.33) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Processing triggers for ca-certificates (20180409) ...
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
done.
Processing triggers for ureadahead (0.100.0-21) ...
Processing triggers for libc-bin (2.27-3ubuntu1) ...

Once that has completed, you need to generate the certificates. From the command line run:

# /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh

Note: You may use https://letsencrypt.org/ as alternative for third-party certificate vendor

You will prompted for your email address, and after you have entered that, the script will automate the process of requesting and installing the SSL certs. You will get output similar to the following:

Obtaining a new certificate
Performing the following challenges:
http-01 challenge for {yourdomanin}
Waiting for verification...
Cleaning up challenges
IMPORTANT NOTES:
- Congratulations! Your certificate and chain have been saved at:
/etc/letsencrypt/live/jitsi.beachgeek.co.uk/fullchain.pem
Your key file has been saved at:
/etc/letsencrypt/live/{yourdomain}/privkey.pem
Your cert will expire on 2020-06-04. To obtain a new or tweaked
version of this certificate in the future, simply run certbot-auto
again. To non-interactively renew *all* of your certificates, run
"certbot-auto renew"
- If you like Certbot, please consider supporting our work by:
Donating to ISRG / Let's Encrypt: https://letsencrypt.org/donate
Donating to EFF: https://eff.org/donate-le

That is it: The application is now installed, SSL certificates are configured, and the application is ready to go. The script shuts the server down, so you may need to restart this.

Managing the instance

To stop, start, and check the status of the services, use the following commands:
$ sudo service jitsi-videobridge restart
$ sudo service jitsi-videobridge stop
$ sudo service jitsi-videobridge start
$ sudo service jitsi-videobridge status

Sources:
https://aws.amazon.com/blogs/opensource/getting-started-with-jitsi-an-open-source-web-conferencing-solution/
https://jitsi.org/blog/new-tutorial-installing-jitsi-meet-on-your-own-linux-server/



