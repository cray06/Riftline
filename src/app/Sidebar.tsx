import {
  BarChart3,
  Home,
  Radio,
  Settings2,
  Swords,
  type LucideIcon,
} from "lucide-react";
import { useNavigationStore, type PageId } from "../stores/navigationStore";

type NavItem = { id: PageId; label: string; icon: LucideIcon };

const items: NavItem[] = [
  { id: "dashboard", label: "Dashboard", icon: Home },
  { id: "live-game", label: "Live Game", icon: Radio },
  { id: "match-history", label: "Match History", icon: BarChart3 },
  { id: "champions", label: "Champions", icon: Swords },
  { id: "settings", label: "Settings", icon: Settings2 },
];

export function Sidebar() {
  const page = useNavigationStore((state) => state.page);
  const setPage = useNavigationStore((state) => state.setPage);

  return (
    <aside className="flex w-full flex-col border-b border-line bg-sidebar px-4 py-5 md:min-h-screen md:w-64 md:shrink-0 md:border-b-0 md:border-r md:px-5 md:py-7">
      <div className="flex items-center gap-3 px-2 md:mb-12">
        <div className="flex size-10 items-center justify-center rounded-xl border border-accent/30 bg-accent/10 text-xl font-bold text-accent">
          R
        </div>
        <div>
          <p className="text-lg font-bold tracking-tight text-ink">RiftScope</p>
          <p className="text-[10px] font-semibold uppercase tracking-[0.2em] text-muted">
            Desktop companion
          </p>
        </div>
      </div>
      <nav
        className="mt-5 flex gap-1 overflow-x-auto md:mt-0 md:flex-col"
        aria-label="Primary navigation"
      >
        {items.map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            type="button"
            onClick={() => setPage(id)}
            aria-current={page === id ? "page" : undefined}
            className={`flex shrink-0 items-center gap-3 rounded-xl px-3 py-2.5 text-left text-sm font-medium transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent disabled:cursor-not-allowed disabled:opacity-50 md:w-full ${page === id ? "bg-accent/12 text-accent" : "text-muted hover:bg-white/5 hover:text-ink"}`}
          >
            <Icon size={18} strokeWidth={1.8} aria-hidden="true" />
            <span>{label}</span>
          </button>
        ))}
      </nav>
      <div className="mt-auto hidden border-t border-line px-2 pt-5 md:block">
        <p className="text-xs text-muted">Built for the Rift</p>
      </div>
    </aside>
  );
}
