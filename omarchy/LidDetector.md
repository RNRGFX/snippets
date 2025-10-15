### Ignore system events:
``sudo nano /etc/systemd/logind.conf``
``HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
``

### Create lid action script:
``sudo nano ~/lid-monitor.sh``

### Paste from lid-monitor.sh and enable execution:
``chmod +x ~/lid-monitor.sh``


### Create a file:
``sudo nano ~/.config/systemd/user/lid-monitor.service``

```[Unit]
Description=Lid open/close monitor

[Service]
ExecStart=%h/lid-monitor.sh
Restart=always

[Install]
WantedBy=default.target
```

### Enable and start the service
```
systemctl --user daemon-reload
systemctl --user enable --now lid-monitor.service
```
### Check logs:
```
journalctl --user -u lid-monitor.service -f
```
