# Decentralized AMM Factory & Indexing System

Лабораторный проект децентрализованного приложения (dApp) для развертывания смарт-контрактов торговых пар в сети Sepolia и индексации событий через Graph Protocol.

## 🏗 Архитектура приложения
1. **Smart Contracts (Foundry):** Смарт-контракты фабрики пулов и токенов стандарта ERC-20.
2. **Indexing Layer (The Graph):** Субграф для отслеживания и агрегации блокчейн-событий `PairCreated`.
3. **Frontend Layer (Vanilla JS):** Клиентский интерфейс взаимодействия через провайдер Ethers.js v6 и интеграцию с MetaMask.

## 📍 Детали деплоя (Sepolia Testnet)
* **AMMFactory Contract:** `0xff2435374e70acfff4619ef0e6b337115095937d`
* **SubGraph Query URL:** `https://api.studio.thegraph.com/query/75401/defi-ecosystem/v0.0.2`

## 🚀 Инструкция по запуску локально
1. Убедитесь, что в системе установлен Python.
2. Откройте терминал в корневой директории проекта и запустите сервер:
   ```bash
   python -m http.server 3000