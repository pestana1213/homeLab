# 🏠 Meu Homelab com Ubuntu Server

Este repositório documenta a criação e manutenção do meu homelab, hospedado num portátil com Ubuntu Server.  
Objetivo: Aprender Docker, automação, auto-hospedagem e manter serviços pessoais como Nextcloud, Pi-hole e dashboards.

## 🧱 Infraestrutura

- 💻 Host: Intel i7, 16GB RAM, 512GB SSD + 1TB HDD
- 🐧 SO: Ubuntu Server 24.04 LTS
- 🐳 Docker + Docker Compose
- 📡 Acesso via SSH e web

## 📦 Serviços

| Serviço        | Descrição                          |
|----------------|------------------------------------|
| Pi-hole        | Bloqueador de anúncios na rede     |
| Nextcloud      | Nuvem pessoal                      |
| Portainer      | Gerenciamento de containers        |
| Dashy          | Painel com atalhos dos serviços    |

```bash
cd docker/pihole
docker-compose up -d
```