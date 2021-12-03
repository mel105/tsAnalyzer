function []=plotPrincipalComponents(elemTS)

  figure("Name","PC")
  for pcidx=1:size(elemTS,2)

    subplot(size(elemTS,2),1,pcidx);
    plot(elemTS(:,pcidx),'k-');
    ylabel(sprintf('PC %d',pcidx));
  end

end