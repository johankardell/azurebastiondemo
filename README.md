# azurebastiondemo
Azure Bastion Demo

## Before you start
You need a fairly new az cli, and additionally you need to run this:
```
az extension add --name ssh
chmod 0700 ~/.ssh
chmod 0600 ~/.ssh/id_rsa
chmod 0600 ~/.ssh/id_rsa.pub

vmid=$(az vm show -n vm-ubuntu -g bastion-demo --query id -o tsv)
```

## Connect using az cli through Bastion using ssh key
```
az network bastion ssh --name "bastion" --resource-group "bastion-demo" --target-resource-id $vmid --auth-type ssh-key --username adminuser --ssh-key ~/.ssh/id_rsa
```

## Connect using az cli through Bastion using aad
Make sure you have the role assignment for "Virtual Machine Administrator Login" on the VM you are connecting to.

```
az network bastion ssh --name "bastion" --resource-group "bastion-demo" --target-resource-id $vmid --auth-type aad --username adminuser
```

## Tunnel through Bastion
```
az network bastion tunnel --name "bastion" --resource-group "bastion-demo" --target-resource-id $vmid --resource-port 22 --port 1337

ssh adminuser@localhost -p 1337
```

scp files:
```
Upload: scp -P 1337 test.json adminuser@127.0.0.1:~/test.json
Download: scp -P 1337 adminuser@127.0.0.1:~/test.json test.json
```
