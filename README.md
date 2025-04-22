# 📱 BarCode Scan

Aplicativo desenvolvido em **Dart** com **Flutter** para captura, armazenamento e gerenciamento de códigos de barras.

## 🚀 Funcionalidades

- 📷 Captura de códigos de barras com a câmera do dispositivo  
- 💾 Armazenamento local dos códigos escaneados  
- 🔢 Registro da quantidade associada a cada código  
- 🗑️ Exclusão de códigos individualmente  
- 🔍 Busca rápida do código no Bing  
- 📄 Geração de PDF com os códigos armazenados  
- 📤 Compartilhamento dos códigos via PDF  
- 🎬 Tela de splash animada  

---

## 📦 Tecnologias e Dependências

O projeto utiliza os seguintes pacotes:

### 🔍 Leitura e visualização de códigos
- [`mobile_scanner`](https://pub.dev/packages/mobile_scanner) – escaneamento de códigos de barras  
- [`barcode_widget`](https://pub.dev/packages/barcode_widget) – renderização de códigos de barras  
- [`barcode`](https://pub.dev/packages/barcode) – geração de códigos de barras  

### 🌐 Integração e navegação
- [`web_scraper`](https://pub.dev/packages/web_scraper) – scraping simples para buscas  
- [`url_launcher`](https://pub.dev/packages/url_launcher) – abertura de links no navegador  
- [`get`](https://pub.dev/packages/get) – gerenciamento de rotas e estado  

### 🗃️ Armazenamento local
- [`sqflite`](https://pub.dev/packages/sqflite) – banco de dados SQLite local  
- [`path`](https://pub.dev/packages/path) e [`path_provider`](https://pub.dev/packages/path_provider) – localização de diretórios do sistema  

### 📄 PDF e Compartilhamento
- [`pdf`](https://pub.dev/packages/pdf) – criação de documentos PDF  
- [`printing`](https://pub.dev/packages/printing) – visualização e impressão de PDFs  
- [`share_plus`](https://pub.dev/packages/share_plus) – compartilhamento nativo de arquivos  

### 🎨 UI
- [`animated_splash_screen`](https://pub.dev/packages/animated_splash_screen) – splash screen animada  

---

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma *issue* ou enviar um *pull request*.

---

## 📌 Primeira Versão

> Aplicativo para captura e armazenamento de códigos de barras com funcionalidades de busca, exportação e gerenciamento local.

## 🛠️ Como rodar o projeto

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/Deyweson/barcode_scan_app.git
   cd barcode_scan_app
   ```
1. **Instale as dependências:**
   ```bash
   flutter pub get
   ```
1. **Rode o app:**
   ```bash
   flutter run
   ```
