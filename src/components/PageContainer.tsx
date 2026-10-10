import type { ReactNode } from "react";

type PageContainerProps = {
  eyebrow: string;
  title: string;
  description: string;
  children: ReactNode;
};

export function PageContainer({
  eyebrow,
  title,
  description,
  children,
}: PageContainerProps) {
  return (
    <main className="mx-auto w-full max-w-7xl px-5 pb-10 pt-8 sm:px-8 lg:px-10">
      <div className="mb-8">
        <p className="mb-2 text-xs font-semibold uppercase tracking-[0.2em] text-accent">
          {eyebrow}
        </p>
        <h1 className="text-3xl font-semibold tracking-tight text-ink sm:text-4xl">
          {title}
        </h1>
        <p className="mt-3 max-w-2xl text-sm leading-6 text-muted">
          {description}
        </p>
      </div>
      {children}
    </main>
  );
}
