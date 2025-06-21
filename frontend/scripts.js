// Ensure window.ethereum (MetaMask)  
if (!window.ethereum) {
  alert('MetaMask is required to use this dashboard.');
}

// ——————————————
// 1. GLOBAL SETUP
// ——————————————

let provider, signer;

// Replace these placeholders with your actual contract addresses and ABIs:

// 1A. NFT Mint Contract (Assumes a function `mint(string tokenURI)`)
const MINT_CONTRACT_ADDRESS = "0xXXXXXXXXXXXXXXXXXXXXXX";
const MINT_CONTRACT_ABI = [
  // Minimal ABI: mint(string)
  "function mint(string memory _tokenURI) public returns (uint256)"
];

// 1B. Price Oracle Contract (Assumes a function `getLatestPrice() returns (int256)`)
const PRICE_CONTRACT_ADDRESS = "0xYYYYYYYYYYYYYYYYYYYYYYYYYY";
const PRICE_CONTRACT_ABI = [
  // Minimal ABI: getLatestPrice()
  "function getLatestPrice() public view returns (int256)"
];

// 1C. ERC721 ABI snippet (for NFT Viewer)
const ERC721_ABI = [
  // tokenURI(uint256) returns string
  "function tokenURI(uint256 tokenId) external view returns (string memory)"
];

// Helper to connect wallet on page load
async function initEthers() {
  try {
    await window.ethereum.request({ method: "eth_requestAccounts" });
    provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    console.log(" Wallet connected");
  } catch (err) {
    console.error(" Wallet connection failed:", err);
  }
}

// Call initEthers immediately
initEthers();

// ——————————————
// 2.MINT NFT
// ——————————————

const btnMint = document.getElementById("btn-mint");
const mintStatus = document.getElementById("mint-status");

btnMint.addEventListener("click", async () => {
  const tokenURI = document.getElementById("mint-tokenuri").value.trim();
  if (!tokenURI) {
    mintStatus.textContent = " Enter a valid Token URI.";
    return;
  }

  try {
    mintStatus.textContent = " Sending transaction...";
    const mintContract = new ethers.Contract(
      MINT_CONTRACT_ADDRESS,
      MINT_CONTRACT_ABI,
      signer
    );
    const tx = await mintContract.mint(tokenURI);
    mintStatus.textContent = ` Awaiting confirmation (tx: ${tx.hash})...`;
    await tx.wait();
    mintStatus.textContent = ` Minted successfully! TxHash: ${tx.hash}`;
  } catch (err) {
    console.error(err);
    mintStatus.textContent = ` Error: ${err.message}`;
  }
});

// ——————————————
// 3. REQUEST PRICE(On‐Chain)
// ——————————————

const btnRequestPrice = document.getElementById("btn-request-price");
const priceResult = document.getElementById("price-result");

btnRequestPrice.addEventListener("click", async () => {
  try {
    priceResult.textContent = " Fetching price...";
    const priceContract = new ethers.Contract(
      PRICE_CONTRACT_ADDRESS,
      PRICE_CONTRACT_ABI,
      provider
    );
    const priceRaw = await priceContract.getLatestPrice(); // e.g. returns int256 with 8 decimals
    // If Chainlink style with 8 decimals, divide by 10^8:
    const price = Number(priceRaw) / 1e8;
    priceResult.textContent = ` Latest Price: $${price.toFixed(2)}`;
  } catch (err) {
    console.error(err);
    priceResult.textContent = `❌ Error: ${err.message}`;
  }
});

// ——————————————
// 4. CRYPTO-FEED (CoinGecko)
// ——————————————

const btcPriceEl = document.getElementById("btc-price");
const ethPriceEl = document.getElementById("eth-price");
const feedTimeEl = document.getElementById("feed-time");

async function fetchCryptoPrices() {
  try {
    const res = await fetch(
      "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin%2Cethereum&vs_currencies=usd"
    );
    const data = await res.json();
    const btc = data.bitcoin.usd;
    const eth = data.ethereum.usd;
    const now = new Date().toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit",
    });

    btcPriceEl.textContent = `$${btc.toLocaleString()}`;
    ethPriceEl.textContent = `$${eth.toLocaleString()}`;
    feedTimeEl.textContent = now;
  } catch (err) {
    console.error("Error fetching CoinGecko data:", err);
    btcPriceEl.textContent = "—";
    ethPriceEl.textContent = "—";
    feedTimeEl.textContent = "Error";
  }
}

// Fetch on load and then every 60 seconds
fetchCryptoPrices();
setInterval(fetchCryptoPrices, 60 * 1000);

// ——————————————
// 5. NFT VIEWER
// ——————————————

const btnViewNft = document.getElementById("btn-view-nft");
const nftResult = document.getElementById("nft-result");

btnViewNft.addEventListener("click", async () => {
  const addr = document.getElementById("nft-address").value.trim();
  const tokenIdStr = document.getElementById("nft-tokenid").value.trim();
  if (!ethers.utils.isAddress(addr) || !tokenIdStr) {
    nftResult.innerHTML = "<p>⚠️ Enter valid contract address & token ID.</p>";
    return;
  }

  try {
    nftResult.innerHTML = "<p>⏳ Fetching metadata...</p>";
    const tokenId = ethers.BigNumber.from(tokenIdStr);
    const erc721 = new ethers.Contract(addr, ERC721_ABI, provider);
    const tokenURI = await erc721.tokenURI(tokenId);
    // Fetch metadata JSON
    const metaRes = await fetch(tokenURI);
    const metaJson = await metaRes.json();

    const imgUrl = metaJson.image || metaJson.image_url || "";
    const name = metaJson.name || `Token #${tokenId.toString()}`;
    const desc = metaJson.description || "";

    nftResult.innerHTML = `
      ${imgUrl ? `<img src="${imgUrl}" alt="${name}" />` : ""}
      <pre>Name: ${name}\nDescription: ${desc}\n\n${JSON.stringify(
      metaJson,
      null,
      2
    )}</pre>
    `;
  } catch (err) {
    console.error(err);
    nftResult.innerHTML = `<p>❌ Error: ${err.message}</p>`;
  }
});

// ——————————————
// 6. UPLOAD WIDGET (Placeholder)
// ——————————————

const fileInput = document.getElementById("file-input");
const btnUpload = document.getElementById("btn-upload");
const uploadStatus = document.getElementById("upload-status");

btnUpload.addEventListener("click", async () => {
  const file = fileInput.files[0];
  if (!file) {
    uploadStatus.textContent = "⚠️ No file selected.";
    return;
  }

  // Placeholder: Here you would integrate with IPFS or your preferred storage.
  // For example, use Pinata SDK or web3.storage to upload `file`.
  // This demo simply shows the file name and size.

  uploadStatus.textContent = `📁 Selected: ${file.name} (${(
    file.size / 1024
  ).toFixed(2)} KB) — integrate IPFS upload here.`;
});
