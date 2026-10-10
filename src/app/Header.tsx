import { ShieldCheck } from "lucide-react";
import { StatusBadge } from "../components/StatusBadge";

export function Header() {
  return (
    <header className="flex min-h-17 items-center justify-between gap-4 border-b border-line px-5 sm:px-8 lg:px-10">
      <div className="flex items-center gap-2 text-sm text-muted">
        <ShieldCheck size={17} className="text-accent" aria-hidden="true" />
        <span>RiftScope workspace</span>
      </div>
      <StatusBadge label="Desktop client" tone="neutral" />
    </header>
  );
}
