import "./debug.css";
import { mountDebugPage } from "./DebugPage";

const root = document.getElementById("app");

if (!root) {
  throw new Error("Debug page root element not found.");
}

mountDebugPage(root);