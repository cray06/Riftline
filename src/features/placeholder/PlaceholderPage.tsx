import { ArrowUpRight } from "lucide-react";
import { Card } from "../../components/Card";
import { PageContainer } from "../../components/PageContainer";
import { StatusBadge } from "../../components/StatusBadge";

type PlaceholderPageProps = { title: string; description: string };

export function PlaceholderPage({ title, description }: PlaceholderPageProps) {
  return (
    <PageContainer eyebrow="Workspace" title={title} description={description}>
      <Card className="max-w-2xl">
        <div className="mb-8 flex size-12 items-center justify-center rounded-xl bg-accent/10 text-accent">
          <ArrowUpRight size={24} aria-hidden="true" />
        </div>
        <StatusBadge label="Coming soon" tone="neutral" />
        <p className="mt-4 text-sm leading-6 text-muted">
          This area is ready for a future feature. No game data is accessed yet.
        </p>
      </Card>
    </PageContainer>
  );
}
