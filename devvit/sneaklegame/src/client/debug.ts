import "./debug.css";
import { context } from "@devvit/web/client";
import { mountDebugPage } from "./DebugPage";

const root = document.getElementById("app");

if (!root) {
  throw new Error("Debug page root element not found.");
}

// Touch context so Devvit client bridge initializes for this entrypoint.
void context.postId;

mountDebugPage(root);