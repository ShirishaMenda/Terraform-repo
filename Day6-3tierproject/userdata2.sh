user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
    mkdir -p /var/www/html
    echo "hi siri" > /var/www/html/index.html
  EOF