import React, { useEffect, useState } from "react";
import "./App.css";

// Constants

const App = () => {
  const [currentAccount, setCurrentAccount] = useState(null);

  const checkIfWalletConnected = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        console.log("Connect to the wallet");
        return;
      } else {
        console.log("We have the ethereum object", ethereum);

        const accounts = await ethereum.request({ method: "eth_accounts" });

        if (accounts.length !== 0) {
          const account = accounts[0];
          console.log("Found an authorized account:", account);
          setCurrentAccount(account);
        } else {
          console.log("No authorized account found");
        }
      }
    } catch (error) {
      console.log(error);
    }
  };

  const connectWallet = async () => {
    try {
      const { ethereum } = window;
      if (!ethereum) {
        alert("Get Metamask");
        return;
      }

      const accounts = ethereum.request({ method: "eth_requestAccounts" });
      const account = accounts[0];
      console.log("Connected:", account);
      setCurrentAccount(account);
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    checkIfWalletConnected();
  }, []);

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">⚔️ Metaverse Slayer ⚔️</p>
          <p className="sub-text">Team up to protect the Metaverse!</p>
          <div className="connect-wallet-container">
            <img
              src="https://64.media.tumblr.com/tumblr_mbia5vdmRd1r1mkubo1_500.gifv"
              alt="Monty Python Gif"
            />
            <button
              className="cta-button connect-wallet-button"
              onClick={connectWallet}
            >
              Connect Wallet To Get Started
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;
