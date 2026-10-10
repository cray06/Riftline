import { create } from "zustand";

export type PageId =
  "dashboard" | "live-game" | "match-history" | "champions" | "settings";

type NavigationState = {
  page: PageId;
  setPage: (page: PageId) => void;
};

export const useNavigationStore = create<NavigationState>((set) => ({
  page: "dashboard",
  setPage: (page) => set({ page }),
}));
