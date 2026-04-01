# Trien khai ung dung len Ubuntu Server tu GitHub bang Docker

## 1) Cai dat server

Cap nhat he thong:

sudo apt update
sudo apt upgrade -y

Cai Docker, Compose plugin, Git va UFW:

sudo apt install -y docker.io docker-compose-plugin git ufw

Bat Docker khi khoi dong:

sudo systemctl enable docker
sudo systemctl start docker

Kiem tra:

docker --version
docker compose version
git --version

## 2) Lay source tu GitHub

Tai server:

cd ~
git clone <GITHUB_REPO_URL> deploy
cd deploy

Tao file .env tu mau va sua gia tri that:

cp .env.example .env
nano .env

## 3) Chay docker compose

Khoi dong:

sudo docker compose up --build -d

Xem trang thai container:

sudo docker compose ps

Xem log app:

sudo docker compose logs -f app

Ung dung se chay tai cong 8080.

## 4) Cap nhat phien ban moi tu GitHub

Tai thu muc deploy:

git pull
sudo docker compose up --build -d

## 5) Bao mat co ban

Phan quyen file nhay cam:

chmod 600 .env

UFW:

sudo ufw allow OpenSSH
sudo ufw allow 8080/tcp
sudo ufw deny 3306/tcp
sudo ufw --force enable
sudo ufw status verbose

## 6) SSH key only

Mo file cau hinh SSH:

sudo nano /etc/ssh/sshd_config

Dam bao cac dong sau:

PasswordAuthentication no
PermitRootLogin no

Kiem tra cau hinh va restart dich vu:

sudo sshd -t
sudo systemctl restart ssh

## 7) Ghi chu quan trong cho du an nay

Du an nay la Servlet/JSP va dong goi WAR, vi vay dung Tomcat (khong chay java -jar).

Dockerfile dang su dung multi-stage build: build WAR trong stage dau, image cuoi chi chua WAR + Tomcat, khong chua source code.

Neu ung dung cua ban hien tai dung SQLite thay vi MySQL, can cap nhat ma nguon ket noi CSDL hoac bo service db trong docker-compose.yml de don gian hoa he thong.
