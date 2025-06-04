external_url 'https://gitlab.notclickable.com';
gitlab_rails['smtp_enable'] = true;
gitlab_rails['smtp_address'] = "smtp.sendgrid.net";
gitlab_rails['smtp_port'] = 587;
gitlab_rails['smtp_user_name'] = "apikey";
gitlab_rails['smtp_password'] = "PASSWORD";
gitlab_rails['smtp_domain'] = "smtp.sendgrid.net";
gitlab_rails['smtp_authentication'] = "plain";
gitlab_rails['smtp_enable_starttls_auto'] = true;
gitlab_rails['smtp_tls'] = false;
# If use Single Sender Verification You must configure from. If not fail
# 550 The from address does not match a verified Sender Identity. Mail cannot be sent until this error is resolved.
# Visit https://sendgrid.com/docs/for-developers/sending-email/sender-identity/ to see the Sender Identity requirements
gitlab_rails['gitlab_email_from'] = 'gitlab@notclickable.com';
gitlab_rails['gitlab_email_reply_to'] = 'gitlab@notclickable.com';