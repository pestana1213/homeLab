# 🏠 Meu Homelab com Ubuntu Server

Este repositório documenta a criação e manutenção do meu homelab, hospedado num portátil com Ubuntu Server.
Objetivo: Aprender Docker, automação, auto-hospedagem e manter serviços pessoais como Nextcloud, Pi-hole, dashboards e inteligência artificial local.

## 🧱 Infraestrutura

* 💻 Host: Intel i7, 16GB RAM, 512GB SSD + 1TB HDD
* 🐧 SO: Ubuntu Server 24.04 LTS
* 🐳 Docker + Docker Compose
* 📡 Acesso via SSH e web

## 📦 Serviços

| Serviço   | Descrição                                           |
| --------- | --------------------------------------------------- |
| Pi-hole   | Bloqueador de anúncios na rede                      |
| Nextcloud | Nuvem pessoal                                       |
| Dashy     | Painel com atalhos dos serviços                     |
| myAi      | Ollama (modelos de IA) + Open WebUI (ChatGPT local) |

## 🤖 Modelos de IA suportados (CPU only)

Os modelos são geridos pelo **Ollama** e podem ser trocados facilmente no Open WebUI.

### **Modelos recomendados**

* **Mistral 7B** → rápido, eficiente e boa qualidade geral
* **LLaMA 2 7B Chat** → respostas estilo ChatGPT
* **CodeLlama 7B** → focado em programação

### **Comandos para baixar os modelos**

```bash
docker exec -it ollama ollama pull mistral
docker exec -it ollama ollama pull llama2
docker exec -it ollama ollama pull codellama
```

### **Como usar no Open WebUI**

1. Aceder: `http://{host}:3000`
2. Ir em **Settings → Model**
3. Selecionar o modelo desejado (mistral, llama2, codellama)

> **Notas:**  Modelos 7B usam \~5–7GB de RAM, ideais para CPU. Modelos 13B funcionam mas são bem mais lentos em CPU.

## 🚀 Iniciar todos os containers

```bash
chmod +x initialize.sh
./initialize.sh
```

## 🛑 Parar todos os containers

```bash
chmod +x stop.sh
./stop.sh
```

## 🌐 URL do Dashy

Acede ao painel Dashy no navegador através do endereço:

```bash
http://{host}:8080
```

Substitui {host} pelo IP ou nome do teu servidor.
