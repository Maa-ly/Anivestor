<div style="text-align: center; font-size: 50px; font-weight: bold; color: #80F75A; background-color: #FFE9F800; padding: 20px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
  <a href="https://git.io/typing-svg">
    <img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=900&size=39&pause=1000&color=80F75A&background=FFE9F800&center=true&width=435&lines=ANIVESTOR" alt="Typing SVG" />
  </a>
</div>

# **Anivestor**

Anivestor is a **decentralized investment platform** focused on **livestock (animal) investment**. The platform allows **farmers** to list their livestock for investment, where **investors** can purchase shares in the animals. Investors then receive **daily returns** based on the profits generated by the livestock, making it a unique blend of **agricultural investment** and **blockchain technology**.

Anivestor enables a decentralized marketplace where people can invest in livestock and earn passive income through profit-sharing. It aims to democratize livestock investments and provide farmers with easier access to funding while giving investors a chance to diversify their portfolios.

---

## **Key Features**

### **Livestock Investment**
- Farmers can register and list livestock (e.g., cattle, poultry) and sell shares to investors.
- Investors can buy shares in the livestock and earn a portion of the daily profits generated from the animals.

### **Profit Sharing**
- Investors earn daily profits proportional to the number of shares they own. The profit is calculated and distributed daily.
- Farmers use the funds raised from share sales to support their livestock.

### **Whitelist Mechanism**
- Livestock listings are either **public** (open to anyone) or **private** (restricted to verified users), governed by a whitelist system to manage access.

### **Collateral & Borrowing**
- Farmers can borrow funds to finance their livestock projects, providing collateral in the form of livestock shares. This ensures that the investors are paid their returns.

---

## **Actors**
- **Farmer**: The individual who lists their livestock for investment.
- **Investor**: The individual who buys shares and earns daily profits.
- **Donor**: The individual who contributes funds to support livestock projects.
- **Manager**: The individual virifying registered farmers.

---

## **Sponsors**
- **IEXEC**
- **CITREA**

---

## **Quick Start**

Clone the repository and build the contracts:

```bash
git clone https://github.com/Maa-ly/Anivestor.git
cd Anivestor/contract
forge build
```

```bash
forge script script/DeployAnivestor.s.sol:Deploy --rpc-url https://rpc.testnet.citrea.xyz/ --private-key PRIVATE_KEY --broadcast
```
