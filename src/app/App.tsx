import { useNavigationStore } from "../stores/navigationStore";
import { DashboardPage } from "../features/dashboard/DashboardPage";
import { PlaceholderPage } from "../features/placeholder/PlaceholderPage";
import { AppShell } from "./AppShell";

const placeholderPages = {
  "live-game": {
    title: "Live Game",
    description:
      "Live match insights will appear here when a supported League data source is connected.",
  },
  "match-history": {
    title: "Match History",
    description: "Your recent matches and performance trends will appear here.",
  },
  champions: {
    title: "Champions",
    description: "Champion information and insights will appear here.",
  },
  settings: {
    title: "Settings",
    description: "Application and integration preferences will appear here.",
  },
};

export function App() {
  const page = useNavigationStore((state) => state.page);

  return (
    <AppShell>
      {page === "dashboard" ? (
        <DashboardPage />
      ) : (
        <PlaceholderPage {...placeholderPages[page]} />
      )}
    </AppShell>
  );
}
