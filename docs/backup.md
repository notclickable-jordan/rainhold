# Backup

The backup.sh file in each stack has to be made executable before it can be run. You can do this by running the following command in the terminal:

```bash
chmod +x backup.sh
```

This will create issues in git. To commit the changes, you can run:

```bash
git add backup.sh
git commit -m "Make backup.sh executable"
git pull --rebase
```
