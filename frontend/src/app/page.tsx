import React from 'react';

const PortfolioPage = () => {
  return (
    <main className="min-h-screen bg-[#0a0a0c] text-[#f0f0f2] overflow-hidden selection:bg-emerald-500/30">
      {/* Background Orbs */}
      <div className="absolute top-[-10%] left-[-10%] w-[500px] h-[500px] bg-emerald-500/10 rounded-full blur-[120px] -z-10 animate-pulse" />
      <div className="absolute top-[40%] right-[-10%] w-[400px] h-[400px] bg-blue-500/10 rounded-full blur-[120px] -z-10" />

      {/* Navigation */}
      <nav className="p-8 flex justify-between items-center max-w-7xl mx-auto backdrop-blur-md sticky top-0 z-50">
        <div className="text-2xl font-bold tracking-tighter flex items-center gap-2">
          <div className="w-8 h-8 bg-gradient-to-br from-emerald-400 to-blue-500 rounded-lg" />
          Nexus<span className="text-emerald-400">Retail</span>
        </div>
        <div className="flex gap-12 text-sm font-medium text-zinc-400">
          <a href="#architecture" className="hover:text-emerald-400 transition-colors">Architecture</a>
          <a href="#modeling" className="hover:text-emerald-400 transition-colors">Modeling</a>
          <a href="#analytics" className="hover:text-emerald-400 transition-colors">Analytics</a>
        </div>
        <div>
          <a href="#" className="px-6 py-2.5 bg-emerald-500 hover:bg-emerald-400 text-black text-xs font-bold rounded-full transition-all shadow-lg shadow-emerald-500/20">
            View on GitHub
          </a>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative pt-32 pb-48 px-8 max-w-7xl mx-auto text-center">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 mb-12">
          <span className="block w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
          <span className="text-[10px] font-bold tracking-[0.2em] text-emerald-400 uppercase">Production Ready DWH</span>
        </div>
        <h1 className="text-7xl md:text-8xl font-black tracking-tighter leading-[0.9] mb-8 max-w-5xl mx-auto">
          Modern Data <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 via-blue-400 to-cyan-400">Warehouse Architecture</span>
        </h1>
        <p className="text-xl text-zinc-400 max-w-2xl mx-auto mb-16 leading-relaxed">
          An end-to-end analytics platform for global e-commerce. Scalable, optimized, and built with industry-best practices.
        </p>
        <div className="flex flex-wrap justify-center gap-4">
          {['BigQuery', 'Snowflake', 'Redshift', 'Next.js', 'Python'].map((tech) => (
            <span key={tech} className="px-5 py-2 rounded-xl bg-zinc-900 border border-zinc-800 text-xs font-semibold text-zinc-200">
              {tech}
            </span>
          ))}
        </div>
      </section>

      {/* Architecture Display */}
      <section id="architecture" className="py-24 px-8 max-w-7xl mx-auto">
        <div className="flex flex-col md:flex-row gap-20 items-center">
          <div className="flex-1 space-y-10">
            <h2 className="text-5xl font-black tracking-tight">The Medallion Architecture</h2>
            <div className="space-y-8">
              {[
                { title: 'Bronze Layer', desc: 'Raw ingestion pipeline capturing immutable record history from APIs and cloud storage.', color: 'bg-orange-500/20 border-orange-500/30 text-orange-400' },
                { title: 'Silver Layer', desc: 'Enterprise-wide cleansing, deduplication, and schema enforcement for reliable data.', color: 'bg-zinc-500/10 border-zinc-500/20 text-zinc-400' },
                { title: 'Gold Layer', desc: 'Highly optimized Star Schema designed for high-performance sub-second analyst queries.', color: 'bg-emerald-500/20 border-emerald-500/30 text-emerald-400' }
              ].map((layer, i) => (
                <div key={i} className={`p-8 rounded-3xl border ${layer.color} glass-card`}>
                  <h3 className="text-xl font-bold mb-2 flex items-center gap-3">
                    <span className="text-xs px-2 py-0.5 border border-current rounded uppercase opacity-70">L{i+1}</span>
                    {layer.title}
                  </h3>
                  <p className="text-sm opacity-80 leading-relaxed">{layer.desc}</p>
                </div>
              ))}
            </div>
          </div>
          <div className="flex-1 w-full flex items-center justify-center p-12 bg-zinc-900/50 rounded-[4rem] border border-zinc-800 relative group">
             <div className="absolute inset-0 bg-emerald-500/5 opacity-0 group-hover:opacity-100 transition-opacity rounded-[4rem]" />
             <div className="grid grid-cols-1 gap-8 text-center">
                <div className="w-64 py-8 rounded-2xl bg-zinc-800 border border-zinc-700 shadow-2xl">Sources</div>
                <div className="w-1 h-8 bg-zinc-800 mx-auto" />
                <div className="w-72 py-10 rounded-2xl bg-emerald-500/10 border border-emerald-500/30 shadow-2xl text-emerald-400 font-bold">Data Warehouse</div>
                <div className="w-1 h-8 bg-zinc-800 mx-auto" />
                <div className="w-64 py-8 rounded-2xl bg-zinc-800 border border-zinc-700 shadow-2xl">BI Dashboards</div>
             </div>
          </div>
        </div>
      </section>

      {/* SQL Playground Preview */}
      <section id="modeling" className="py-24 bg-zinc-900/20 border-y border-zinc-800/50">
        <div className="max-w-7xl mx-auto px-8">
           <div className="mb-20">
              <h2 className="text-5xl font-black mb-6">Advanced Dimensional Modeling</h2>
              <p className="text-zinc-400 text-xl max-w-2xl">Implementing SCD Type 2 and high-performance partitioning in SQL.</p>
           </div>
           
           <div className="p-1 rounded-3xl bg-gradient-to-b from-zinc-800 to-transparent">
              <div className="bg-[#0e0e11] rounded-[calc(1.5rem-4px)] p-12 overflow-hidden border border-zinc-800 shadow-2xl relative">
                  <div className="flex gap-2 mb-8">
                    <div className="w-3 h-3 rounded-full bg-red-500/50" />
                    <div className="w-3 h-3 rounded-full bg-amber-500/50" />
                    <div className="w-3 h-3 rounded-full bg-emerald-500/50" />
                  </div>
                  <pre className="text-sm font-mono text-emerald-400 leading-relaxed overflow-x-auto">
                    <code>{`
CREATE OR REPLACE TABLE nexus_dw.fact_orders
PARTITION BY DATE(ordered_at)
CLUSTER BY customer_id, order_status
AS
SELECT 
    order_id,
    customer_id,
    ordered_at,
    total_amount,
    EXTRACT(DATE FROM ordered_at) as order_date_key
FROM nexus_dw.stg_orders;
                    `}</code>
                  </pre>
                  <div className="absolute top-12 right-12 text-[10px] font-bold text-zinc-600 bg-zinc-900/50 px-3 py-1 border border-zinc-800 rounded">
                    BIGQUERY_OPTIMIZED.SQL
                  </div>
              </div>
           </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-20 border-t border-zinc-900 text-center">
        <p className="text-zinc-500 text-xs font-medium tracking-[0.3em] uppercase">Developed with Nexus Architecture</p>
      </footer>
    </main>
  );
};

export default PortfolioPage;
