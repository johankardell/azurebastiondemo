# azurebastiondemo
Azure Bastion Demo


## Connect using az cli through Bastion
You need a fairly new az cli, and additionally you need to run this:
```
az extension add --name ssh
chmod 0700 ~/.ssh
chmod 0600 ~/.ssh/id_rsa
chmod 0600 ~/.ssh/id_rsa.pub
```


```
vmid=$(az vm show -n vm-ubuntu -g bastion-demo --query id -o tsv)

az network bastion ssh --name "bastion" --resource-group "bastion-demo" --target-resource-id $vmid --auth-type ssh-key --username adminuser --ssh-key ~/.ssh/id_rsa
```

## Tunnel through Bastion
```
vmid=$(az vm show -n vm-ubuntu -g bastion-demo --query id -o tsv)

az network bastion tunnel --name "bastion" --resource-group "bastion-demo" --target-resource-id $vmid --resource-port 22 --port 1337

ssh adminuser@localhost -p 1337
```