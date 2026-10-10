import { useEffect, useState } from "react";
import { Activity, Clock3, Cpu, Layers3 } from "lucide-react";
import { Card } from "../../components/Card";
import { PageContainer } from "../../components/PageContainer";
import { StatusBadge } from "../../components/StatusBadge";
import { backendApi } from "../../lib/tauri/backendApi";
import type { BackendStatus } from "../../types/backend";

type DashboardState =
  | { kind: "loading" }
  | { kind: "ready"; status: BackendStatus; reply: string }
  | { kind: "error"; message: string };

export function DashboardPage() {
  const [state, setState] = useState<DashboardState>({ kind: "loading" });

  useEffect(() => {
    let active = true;

    Promise.all([backendApi.ping(), backendApi.getStatus()])
      .then(([reply, status]) => {
        if (active) setState({ kind: "ready", reply, status });
      })
      .catch((error: unknown) => {
        if (active)
          setState({
            kind: "error",
            message: error instanceof Error ? error.message : String(error),
          });
      });

    return () => {
      active = false;
    };
  }, []);

  const status = state.kind === "ready" ? state.status : null;

  return (
    <PageContainer
      eyebrow="Overview"
      title="Dashboard"
      description="A clear view of your desktop companion and its backend connection."
    >
      <div className="mb-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
        <Card eyebrow="Backend" title="Connection">
          <div className="mb-5 flex size-11 items-center justify-center rounded-xl bg-accent/10 text-accent">
            <Activity size={22} aria-hidden="true" />
          </div>
          <StatusBadge
            label={
              state.kind === "loading"
                ? "Connecting"
                : state.kind === "ready"
                  ? "Online"
                  : "Unavailable"
            }
            tone={
              state.kind === "loading"
                ? "warning"
                : state.kind === "ready"
                  ? "success"
                  : "danger"
            }
          />
          <p className="mt-4 text-sm text-muted">
            {state.kind === "ready"
              ? `Rust replied: ${state.reply}`
              : state.kind === "error"
                ? state.message
                : "Checking the desktop backend…"}
          </p>
        </Card>
        <Card eyebrow="Runtime" title="Platform">
          <div className="mb-5 flex size-11 items-center justify-center rounded-xl bg-accent/10 text-accent">
            <Cpu size={22} aria-hidden="true" />
          </div>
          <p className="text-xl font-semibold text-ink">
            {status ? `${status.os} · ${status.architecture}` : "—"}
          </p>
          <p className="mt-2 text-sm text-muted">
            Reported by the Rust backend
          </p>
        </Card>
        <Card eyebrow="Application" title="Version">
          <div className="mb-5 flex size-11 items-center justify-center rounded-xl bg-accent/10 text-accent">
            <Layers3 size={22} aria-hidden="true" />
          </div>
          <p className="text-xl font-semibold text-ink">
            {status ? `v${status.app_version}` : "—"}
          </p>
          <p className="mt-2 text-sm text-muted">
            RiftScope desktop foundation
          </p>
        </Card>
      </div>
      <Card title="Session details" className="max-w-4xl">
        <div className="grid gap-5 border-t border-line pt-5 sm:grid-cols-2">
          <div>
            <div className="mb-2 flex items-center gap-2 text-sm text-muted">
              <Clock3 size={16} aria-hidden="true" /> Started at
            </div>
            <p className="text-sm font-medium text-ink">
              {status ? new Date(status.started_at).toLocaleString() : "—"}
            </p>
          </div>
          <div>
            <p className="mb-2 text-sm text-muted">Backend status</p>
            <p className="text-sm font-medium capitalize text-ink">
              {status?.status ?? "—"}
            </p>
          </div>
        </div>
      </Card>
    </PageContainer>
  );
}
