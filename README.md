# Hammer patch by host collection
### Configuring the hammer cli 
This assumes you have a Red Hat Satellite server 6.x installed with the Hammer command configured for non-interactive commands. 

- Create the ~/.hammer/cli_config.yml 
- Add the following lines 
```
:foreman:
 :host: 'https://satellite.example.com/'
 :username: 'username'
 :password: 'password'
```

- chmod 600 ~/.hammer/cli_config.yml

