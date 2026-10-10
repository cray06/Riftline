import type { ReactNode } from "react";
import { Header } from "./Header";
import { Sidebar } from "./Sidebar";

export function AppShell({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen bg-canvas text-ink md:flex">
      <Sidebar />
      <div className="min-w-0 flex-1">
        <Header />
        {children}
      </div>
    </div>
  );
}
